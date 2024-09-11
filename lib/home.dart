import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

import 'note.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = [];
  bool _isGrid = true; // Track the current view mode

  final List<String> _quotes = [
    "Words have power.",
    "Storytelling matters.",
    "Write your truth.",
    "Find your voice.",
    "Let words flow.",
    "Paint with words.",
    "Weave tales of wonder.",
    "Capture the essence.",
    "Explore the unknown.",
    "Ignite the imagination.",
    "Challenge the ordinary.",
    "Dance on the page.",
    "Embrace the chaos.",
    "Play with language.",
    "Find your rhythm.",
    "Question everything.",
    "Dare to be different.",
    "Write what you love.",
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadViewMode();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final quote = _quotes[random.nextInt(_quotes.length)];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
          title: Text(quote),
        actions: [
          IconButton(
            icon:
                Icon(_isGrid ? Icons.list_alt_rounded : Icons.grid_on_rounded),
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: _isGrid
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onTap: () {
                      _navigateToNote(note);
                    },
                    onLongPress: () {
                      _showNoteOptions(context, note);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4.0),
                            SizedBox(
                              child: Text(
                                note.content.length > 100
                                    ? '${note.content.substring(0, 100)}...'
                                    : note.content,
                                style: const TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        note.content.length > 100
                            ? '${note.content.substring(0, 100)}...'
                            : note.content,
                        style: const TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      onTap: () {
                        _navigateToNote(note);
                      },
                      onLongPress: () {
                        _showNoteOptions(context, note);
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNote(null);
        },
        child: Image.asset('assets/icon/ic.png'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _navigateToNote(Note? note) async {
    final result = await showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: NotePage(
              note: note,
              onDelete: (noteToDelete) {
                // Add onDelete callback
                setState(() {
                  notes.remove(noteToDelete);
                });
                _saveNotes();
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        if (note == null) {
          notes.add(result);
        } else {
          final index = notes.indexOf(note);
          notes[index] = result;
        }
      });
      _saveNotes();
    }
  }

  void _showNoteOptions(BuildContext context, Note note) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context, 'edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_rounded),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context, 'delete');
              },
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      if (result == 'edit') {
        _navigateToNote(note);
      } else if (result == 'delete') {
        setState(() {
          notes.remove(note);
        });
        _saveNotes();
      }
    }
  }

  _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList('notes');
    if (notesJson != null) {
      setState(() {
        notes =
            notesJson.map((json) => Note.fromJson(jsonDecode(json))).toList();
      });
    }
  }

  _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => jsonEncode(note.toJson())).toList();
    prefs.setStringList('notes', notesJson);
  }

  void _toggleViewMode() {
    setState(() {
      _isGrid = !_isGrid;
    });
    _saveViewMode();
  }

  _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGrid = prefs.getBool('isGrid') ?? true; // Default to grid view
    });
  }

  _saveViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isGrid', _isGrid);
  }
}

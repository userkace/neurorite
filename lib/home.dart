import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:math';

import 'note.dart';

import 'theme/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = [];
  List<Note> _filteredNotes = [];
  bool _isGrid = true; // Track the current view mode

  final TextEditingController _searchController = TextEditingController();

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
    "Dare to be different.",
    "Write what you love.",
    "Question everything.",
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes().then((_) {
      // Load notes first
      _filterNotes(''); // Then filter with empty query
    });
    _loadViewMode();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final quote = _quotes[random.nextInt(_quotes.length)];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20), // Example: add left padding
          child: BackButton(
            color: Colors.white70,
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        title: Text(
          quote,
          style: TextStyle(
            fontSize: 25,
            fontFamily: GoogleFonts.getFont('Satisfy').fontFamily,
            color: Colors.white70, // Change the color here
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20), // Example padding
            child: IconButton(
              icon: Icon(
                  _isGrid ? Icons.list_alt_rounded : Icons.grid_on_rounded),
              color: Colors.white70,
              onPressed: _toggleViewMode,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        decoration: AppBackground.background,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white70), // Text color
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(
                    color: Colors.white38,
                    fontFamily: GoogleFonts.getFont('Outfit').fontFamily,
                  ), // Hint text color
                  prefixIcon: const Icon(Icons.search,
                      color: Colors.white70), // Icon color
                  enabledBorder: const UnderlineInputBorder(
                    // Border color
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    // Focused border color
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                onChanged: (text) {
                  _filterNotes(text);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: _filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = _filteredNotes[index];
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 4.0),
                                    SizedBox(
                                      child: Text(
                                        note.content,
                                        style:
                                            const TextStyle(color: Colors.grey),
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
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
                        itemCount: _filteredNotes.length, // Use filtered notes
                        itemBuilder: (context, index) {
                          final note = _filteredNotes[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                note.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                note.content,
                                style: const TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNote(null);
        },
        child: ClipRRect(
          // Optional: Add shape if needed
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            decoration: AppBackground.background,
            child: Image.asset('assets/icon/ic.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _filterNotes(String query) {
    setState(() {
      _filteredNotes = notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToNote(Note? note) async {
    final result = await showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: NotePage(
                note: note,
                onSave: () {
                  // Pass the callback
                  _saveNotes();
                  _loadNotes().then((_) {
                    _filterNotes('');
                    setState(() {});
                  });
                },
                onDelete: (noteToDelete) {
                  setState(() {
                    notes.remove(noteToDelete);
                    _filterNotes('');
                  });
                  _saveNotes();
                },
              ),
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
      _loadNotes().then((_) {
        _filterNotes('');
        setState(() {});
      });
    }
  }

  void _showNoteOptions(BuildContext context, Note note) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
          _filterNotes(''); // Update filtered list
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

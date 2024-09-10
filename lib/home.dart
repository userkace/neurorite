import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'note.dart'; // Import your note page

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = [];
  bool _isGrid = true; // Track the current view mode

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadViewMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list_alt_rounded : Icons.grid_on_rounded),
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isGrid
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.75,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];return GestureDetector(
              onTap: () {
                _navigateToNote(note);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
            return Card( // Wrap ListTile content in a Card
              child: ListTile(title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold),),
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
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNote(null);
        },
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _navigateToNote(Note? note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotePage(note: note),
      ),
    );

    if (result != null) {
      if (result is Note) {
        setState(() {
          if (note == null) {
            notes.add(result);
          } else {
            final index = notes.indexOf(note);
            notes[index] = result;
          }
        });
        _saveNotes();
      } else if (result == 'delete') {
        setState(() {
          notes.remove(note);
        });
        _saveNotes();
      }
    }
  }_loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList('notes');
    if (notesJson != null) {
      setState(() {
        notes = notesJson.map((json) => Note.fromJson(jsonDecode(json))).toList();
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
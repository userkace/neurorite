import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'note.dart'; // Import your note page

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = []; // List to store notes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            onTap: () {
              _navigateToNote(notes[index]);
            },
          );
        },),
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

    if (result != null && result is Note) {
      setState(() {
        if (note == null) {
          // Add new note
          notes.add(result);
        } else {
          // Update existing note
          final index = notes.indexOf(note);
          notes[index] = result;
        }
      });
    }
  }
}
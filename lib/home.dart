import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hugeicons/hugeicons.dart';
import 'dart:convert';

import 'note.dart';

import 'theme/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Note> notes = [];
  List<Note> _filteredNotes = [];
  bool _isGrid = true; // Track the current view mode

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes().then((_) {
      // Load notes first
      _filterNotes('');
    });
    _loadViewMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: true,
        backgroundColor: const Color(0xFF000000),
        leading: InkWell(
          onTap: () {
            _toggleViewMode();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          enableFeedback: false,
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedSetting07,
            color: Colors.white,
            size: 22,
          ),
        ),
        title: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8.0), // Adjust radius as needed
              border: Border.all(
                color: Colors.white70, // Outline color
                width: 1.0, // Outline width
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white70),
              decoration: const InputDecoration(
                hintText: 'Explore your mind...',
                hintStyle: TextStyle(
                  color: Colors.white38,
                  fontFamily: 'Outfit',
                ),
                border: InputBorder.none, // Remove underline border
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0), // Add padding
              ),
              onChanged: (text) {
                _filterNotes(text);
              },
            ),
          ),
        ),
        actions: [
          Padding(
              padding:
                  const EdgeInsets.only(right: 20, left: 16), // Example padding
              child: InkWell(
                onTap: () {
                  _toggleViewMode();
                },
                child: HugeIcon(
                  icon: _isGrid
                      ? HugeIcons.strokeRoundedListView
                      : HugeIcons.strokeRoundedGridView,
                  color: Colors.white,
                  size: 22.0,
                ),
              )),
        ],
      ),
      body: Container(
        decoration: AppBackground.mainBackground,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
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
                              color: const Color(
                                  0xFF0a0a0a), // Set background color
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          if (note
                                              .isPinned) // Check if note is pinned
                                            const TextSpan(
                                              text: '● ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Outfit',
                                              ),
                                            ),
                                          TextSpan(
                                            text: note.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Outfit',
                                              color: Color(0xFFF0F0F0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 4.0),
                                    SizedBox(
                                      child: Text(
                                        note.content,
                                        style: const TextStyle(
                                          color: Color(
                                              0xff5a5a5a), // Set text color
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 6,
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
                          return Stack(
                            // Wrap with Stack to add the line
                            children: [
                              Card(
                                color: const Color(
                                    0xFF0a0a0a), // Set background color
                                child: ListTile(
                                  title: Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Outfit',
                                      color:
                                          Color(0xFFF0F0F0), // Set text color
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    note.content,
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      color:
                                          Color(0xff5a5a5a), // Set text color
                                    ),
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
                              ),
                              if (note.isPinned) // Show line if pinned
                                Positioned(
                                  left: 6,
                                  top: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6.0, bottom: 6.0),
                                    child: ClipRRect(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left: Radius.circular(8.0),
                                      ),
                                      child: Container(
                                        width: 4, // Line width
                                        color: Colors.purple, // Line color
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(1), // Glow color
              spreadRadius: 200, //Spread radius
              blurRadius: 250, // Blur radius
              offset: const Offset(0, 150), // Offset
            ),
            BoxShadow(
              color: Colors.purple.withOpacity(0.5), // Glow color
              spreadRadius: 5, //Spread radius
              blurRadius: 100, // Blur radius
              offset: const Offset(0, 3), // Offset
            ),
          ],
        ),
        child: InkWell(
          onTap: null,
          child: GestureDetector(
            onTap: null,
            // Used this weird ass logic to get pass the shadow being clickable...
            behavior: HitTestBehavior.translucent,
            child: Material(
              color: const Color(0xFF000000),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              clipBehavior: Clip.antiAlias, // Clip content to rounded corners
              child: GestureDetector(
                onTap: () {
                  _navigateToNote(null);
                },
                // splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                child: const SizedBox(
                  width: 69.0,
                  height: 80.0,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center content vertically
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedAddCircle,
                        color: Colors.purple,
                        size: 35.0,
                      ),
                      SizedBox(
                          height: 3.0), // Add spacing between icon and text
                      Text(
                        'New',
                        style: TextStyle(
                          fontSize: 12.0, // Adjust font size as needed
                          color: Colors.purple, // Adjust text color as needed
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _filterNotes(String query) {
    setState(() {
      _filteredNotes = notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList()
        ..sort((a, b) {
          // Apply sorting after filtering
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return 0;
        });
    });
  }

  void _navigateToNote(Note? note) async {
    final result = await showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          backgroundColor: const Color(0xFF0f0f0f),
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
        color: const Color(0xFF0f0f0f), // Set background color
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Theme(
          // Wrap with Theme widget
          data: ThemeData(
            brightness: Brightness.dark, // Set brightness to dark
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white), // Set text color
            ),
            iconTheme:
                const IconThemeData(color: Colors.white), //Set icon color
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(note.isPinned
                    ? Icons.push_pin_rounded
                    : Icons.push_pin_outlined),
                title:
                    (note.isPinned ? const Text('Unpin') : const Text('Pin')),
                onTap: () {
                  setState(() {
                    note.isPinned = !note.isPinned;
                    _filterNotes('');
                  });
                  Navigator.pop(context); // Close the bottom sheet
                  _saveNotes(); // Save the changes
                },
              ),
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

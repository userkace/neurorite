import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hugeicons/hugeicons.dart';
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
      _filterNotes('');
      _sortNotes();
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
          style: const TextStyle(
            fontSize: 25,
            fontFamily: 'Satisfy', //GoogleFonts.getFont('Satisfy').fontFamily,
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
                decoration: const InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(
                    color: Colors.white38,
                    fontFamily:
                        'Outfit', //GoogleFonts.getFont('Satisfy').fontFamily,
                  ), // Hint text color
                  prefixIcon:
                      Icon(Icons.search, color: Colors.white70), // Icon color
                  enabledBorder: UnderlineInputBorder(
                    // Border color
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
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
                            // Wrap with Stack to add the line
                            child: Card(
                              color: const Color(
                                  0xFF000000), // Set background color
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color(0xFFF0F0F0), // Set text color
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
                                              0xFFF0F0F0), // Set text color
                                        ),
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
                          return Stack(
                            // Wrap with Stack to add the line
                            children: [
                              Card(
                                color: const Color(
                                    0xFF000000), // Set background color
                                child: ListTile(
                                  title: Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color(0xFFF0F0F0), // Set text color
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    note.content,
                                    style: const TextStyle(
                                      color:
                                          Color(0xFFF0F0F0), // Set text color
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
                                  left: 4,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 4, // Line width
                                    color: Colors.purple, // Line color
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
              color: Colors.purple.withOpacity(0.5), // Glow color
              spreadRadius: 5, //Spread radius
              blurRadius: 100, // Blur radius
              offset: const Offset(0, 3), // Offset
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            _navigateToNote(null);
          },
          backgroundColor: const Color(0xFF000000),
          shape: CustomFABShape(), // Use the custom shape
          // child: const Icon(Icons.add, color: Colors.white),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: Colors.purple,
            size: 30.0,
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
          .toList();
    });
  }

  void _navigateToNote(Note? note) async {
    final result = await showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          backgroundColor: Color(0xFF0f0f0f),
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
                title: (note.isPinned ? Text('Unpin') : Text('Pin')),
                onTap: () {
                  setState(() {
                    note.isPinned = !note.isPinned;
                    _sortNotes(); // Sort notes after pinning/unpinning
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

  void _sortNotes() {
    setState(() {
      _filteredNotes.sort((a, b) {
        // Sort pinned notes to the top
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return 0; // Maintain original order for non-pinned notes
      });
    });
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

class CustomFABShape extends ShapeBorder {
  final double borderRadius;

  CustomFABShape({this.borderRadius = 10.0});
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path(); // Not used for FAB
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double radius = borderRadius;
    final double width = rect.width;
    final double height = rect.height;

    return Path()
      ..moveTo(0, height) // Start at bottom left
      ..lineTo(0, radius) // Lineto top left curve start
      ..arcToPoint(Offset(radius, 0),
          radius: Radius.circular(radius)) // Top left curve
      ..lineTo(width - radius, 0) // Line to top right curve start
      ..arcToPoint(Offset(width, radius),
          radius: Radius.circular(radius)) // Top right curve
      ..lineTo(width, height) // Line to bottom right
      ..close(); // Close the path
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return CustomFABShape(borderRadius: borderRadius * t);
  }
}

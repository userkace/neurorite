import 'package:flutter/material.dart';
import 'package:neurorite/services/firestore.dart';
import 'package:neurorite/models/unsaved.dart';

final FirestoreService firestoreService = FirestoreService();

class Note {
  String id;
  String title;
  String content;
  bool isPinned;

  Note(
      {required this.id,
      required this.title,
      required this.content,
      this.isPinned = false});

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        isPinned = json['isPinned'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'isPinned': isPinned,
      };
}

class NotePage extends StatefulWidget {
  final Note? note;
  final Function(Note)? onDelete;
  final VoidCallback? onSave; // Callback function

  const NotePage({
    super.key,
    this.note,
    this.onDelete,
    this.onSave,
  });

  @override
  NotePageState createState() => NotePageState();
}

class NotePageState extends State<NotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  String _initialTitle = '';
  String _initialContent = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _initialTitle = _titleController.text;
    _initialContent = _contentController.text;

    // Add listeners to detect changes
    if (widget.note!= null){
      _titleController.addListener(
          _onTextChanged
      );
      _contentController.addListener(
          _onTextChanged
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Theme(
        // Wrap with Theme widget
        data: ThemeData(
          popupMenuTheme: const PopupMenuThemeData(
            color: Colors.black, // Set popup menu background color
          ),
          scaffoldBackgroundColor: const Color(0xFF0f0f0f),
          // Set background color
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0f0f0f), // Set app bar background color
            iconTheme: IconThemeData(color: Colors.white), // Set icon color
            titleTextStyle:
                TextStyle(color: Colors.white), // Set title text color
          ),
          textTheme: const TextTheme(
            bodyMedium:
                TextStyle(color: Colors.white), // Set default text color
          ),
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.white54), // Set hint text color
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: -5.0,
            title: TextField(
              controller: _titleController,
              style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Enter your title',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  if (_titleController.text != _initialTitle ||
                      _contentController.text != _initialContent) {
                    final shouldSave = await showDialog(
                      context: context,
                      builder: (context) => const UnsavedChangesDialog(),
                    );
                    if (shouldSave == true) {
                      _saveNote();
                    } else if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                }),
            actions: [
              if (widget.note == null ) Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    _saveNote();
                  },
                ),
              ),
              if (widget.note != null) IconButton(
                  icon: Icon(widget.note?.isPinned ?? false
                      ? Icons.push_pin
                      : Icons.push_pin_outlined),
                  onPressed: () async {
                    setState(() {
                      widget.note!.isPinned = !widget.note!.isPinned;
                    });
                    await firestoreService.updateNote(
                      widget.note!.id,
                      _titleController.text,
                      _contentController.text,
                      widget.note!.isPinned,
                    );
                  },
                ),
              if (widget.note != null) PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'save') {
                    _saveNote();
                  } else if (value == 'delete') {
                    _deleteNote();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      value: 'save',
                      child: ListTile(
                        leading: const Icon(Icons.save_rounded,
                            color: Colors.white70), // Set icon color
                        title: const Text('Save',
                            style: TextStyle(
                                color: Colors.white70)), // Set text color
                        onTap: () {
                          Navigator.pop(context, 'save');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      value: 'delete',
                      child: ListTile(
                        leading: const Icon(Icons.delete_forever_rounded,
                            color: Colors.white70), // Set icon color
                        title: const Text('Delete',
                            style: TextStyle(
                                color: Colors.white70)), // Set text color
                        onTap: () {
                          Navigator.pop(context, 'delete');
                        },
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: TextField(
              controller: _contentController,
              maxLines: null,
              style: const TextStyle(
                  color: Colors.white), // Set text color to white
              decoration: const InputDecoration(
                hintText: 'Enter your note',
                hintStyle:
                    TextStyle(color: Colors.white54), // Set hint text color
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    if (_titleController.text.isNotEmpty) {
    try {
      if (widget.note != null && widget.note!.id.isNotEmpty) {
        await firestoreService.updateNote(
          widget.note!.id,
          _titleController.text,
          _contentController.text,
          widget.note?.isPinned ?? false,
        );
      } else {
        await firestoreService.addNote(
          _titleController.text,
          _contentController.text,
          widget.note?.isPinned ?? false,
        );
      }
        Navigator.pop(context);
        widget.onSave?.call();
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
            content: Text('Error saving note: $e'),
            contentTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: const Color(0xFF0f0f0f),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
          content: const Text('Title or content cannot be empty'),
          contentTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color(0xFF0f0f0f),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _autoSaveNote() async{
    if (_titleController.text.isNotEmpty) {
      try {
        if (widget.note != null && widget.note!.id.isNotEmpty) {
          await firestoreService.updateNote(
            widget.note!.id,
            _titleController.text,
            _contentController.text,
            widget.note?.isPinned ?? false,
          );
        } else {
          await firestoreService.addNote(
            _titleController.text,
            _contentController.text,
            widget.note?.isPinned ?? false,
          );
        }
        widget.onSave?.call();
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
            content: Text('Error saving note: $e'),
            contentTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: const Color(0xFF0f0f0f),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
          content: const Text('Title or content cannot be empty'),
          contentTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color(0xFF0f0f0f),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _deleteNote() async {
    if (widget.note != null) {
      try {
        await firestoreService
            .deleteNote(widget.note!.id); // Delete from Firestore
        widget.onDelete?.call(widget.note!); // Notify parent widget
        Navigator.pop(context); // Go back
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
            content: Text('Error deleting note: $e'),
            contentTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: const Color(0xFF0f0f0f),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    } else {
      Navigator.pop(context); // Just go back if it's a new note
    }
  }

  void _onTextChanged() {
    if (_titleController.text != _initialTitle ||
        _contentController.text != _initialContent) {
      _autoSaveNote();
      _initialTitle = _titleController.text;
      _initialContent = _contentController.text;
    }
  }

}



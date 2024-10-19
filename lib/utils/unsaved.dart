import 'package:flutter/material.dart';

class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unsaved Changes'),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
      content: const Text('Do you want to save this note?'),
      contentTextStyle: const TextStyle(color: Colors.white),
      backgroundColor: const Color(0xFF0f0f0f),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

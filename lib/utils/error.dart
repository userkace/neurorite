import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String content;

  const ErrorDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
      content: Text(content),
      contentTextStyle: const TextStyle(color: Colors.white),
      backgroundColor: const Color(0xFF0f0f0f),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

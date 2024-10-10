import 'package:flutter/material.dart';

class AppBackground {
  static const Decoration background = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0f0f0f),
        Color(0xFF0f0f0f),
      ],
    ),
  );
}

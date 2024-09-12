import 'package:flutter/material.dart';

class AppBackground {
  static const Decoration background = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFEB3678),
        Color(0xFF4F1787),
        Color(0xFF180161),
      ],
    ),
  );
}

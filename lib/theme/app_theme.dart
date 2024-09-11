import 'package:flutter/material.dart';

// themes
class AppTheme {
    static final ThemeData lightTheme = ThemeData(
        // general app scheme
        colorScheme: const ColorScheme(
            brightness: Brightness.light,

            primary: Color(0xFF6822AE),
            onPrimary: Colors.white,

            secondary: Color(0xB82B0E48),
            onSecondary: Colors.white,

            error: Color(0xFFFF474D),
            onError: Colors.white,

            surface: Colors.white,
            onSurface: Color(0xFF2B2B2B)
        ),
    );
}
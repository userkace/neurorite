import 'package:flutter/material.dart';

// themes
class AppTheme {
  // main colors of use
  static const Color primary = Color(0xFF6B71FF);
  static const Color secondary = Color(0xFF464EFF);
  static const Color tertiary = Color(0xFF2029FF);
  static const Color error = Color(0xFFFF474D);
  static const Color background = Color(0xFF1E1E1E);

  // general app scheme
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        tertiary: tertiary,
        onTertiary: Colors.white,
        error: error,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xFF2B2B2B)),
  );

  static final ThemeData textFieldTheme = ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF3EFEF),
      labelStyle: TextStyle(fontSize: 12.0),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle:
          TextStyle(color: primary, fontWeight: FontWeight.bold),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: error, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: error, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    ),
  );

  static final ThemeData enterButtonTheme = ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return secondary;
      return tertiary;
    }),
    foregroundColor: const WidgetStatePropertyAll<Color>(Color(0xFFFFFFFF)),
    fixedSize: const WidgetStatePropertyAll<Size>(Size(100.0, 40.0)),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  )));
}

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

    static final ThemeData textFieldTheme = ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2F104F), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2F104F), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6822AE), width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF474D), width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF474D), width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6822AE), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      );

    static final ThemeData enterButtonTheme = ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) return const Color(0xB82B0E48);
                return const Color(0xFF6822AE);
            }),
            foregroundColor: const WidgetStatePropertyAll<Color>(Color(0xFFFFFFFF)),

            fixedSize: const WidgetStatePropertyAll<Size>(Size(100.0, 40.0)),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
            ),
        )
      )
    );
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
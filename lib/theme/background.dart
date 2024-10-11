import 'package:flutter/material.dart';

class AppBackground {
  static const Decoration mainBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1E1E1E),
        Color(0xFF1E1E1E),
      ],
    ),
  );

  static Widget coloredCircleBg = Positioned(
              top: -163,
              left: -100,
              child: Container(
                height: 775,
                width: 762,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE99C9C),
                      Color(0xFFA872FF)
                    ]
                  ),
                ),
              ));
}

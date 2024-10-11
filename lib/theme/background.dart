import 'dart:ui';
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
              colors: [Color(0xFFE99C9C), Color(0xFFA872FF)]),
        ),
      ));
}

class BackgroundTest extends StatelessWidget {
  final bool colored;

  const BackgroundTest({this.colored = true});

  @override
  Widget build(BuildContext context) {
    final mainEllipseWidth = MediaQuery.of(context).size.width * (562 / 412);
    final mainEllipseHeight = MediaQuery.of(context).size.height * (575 / 917);
    final mainEllipseTopOffset =
        MediaQuery.of(context).size.height * (-163 / 917);

    return Stack(children: [
      Positioned(
          top: mainEllipseTopOffset -
              (((mainEllipseHeight * 1.15) - mainEllipseHeight) / 2),
          left: (MediaQuery.of(context).size.width / 2) -
              (MediaQuery.of(context).size.width * (562 / 412) * 1.15 / 2),
          child: Container(
            width: mainEllipseWidth * 1.15,
            height: mainEllipseHeight * 1.15,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF787DF6), Color(0xFF565CFF)]),
            ),
          )),
      Positioned(
          top: mainEllipseTopOffset,
          left:
              (MediaQuery.of(context).size.width / 2) - (mainEllipseWidth / 2),
          child: Container(
            width: mainEllipseWidth,
            height: mainEllipseHeight,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE99C9C), Color(0xFFA872FF)]),
            ),
          ))
    ]);
  }
}

class DialogBackground extends StatelessWidget {
  final Widget? child;

  const DialogBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 150,
              decoration: BoxDecoration(
                color: const Color(0x54FFFFFF),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  width: 2,
                  color: const Color(0x1aF1F1F1),
                ),
              ),
              child: child),
        ),
      ),
    );
  }
}

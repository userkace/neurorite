import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:neurorite/auth/login.dart';
import 'package:neurorite/firebase_options.dart';
import 'package:neurorite/screens/home.dart';
import 'package:neurorite/theme/app_theme.dart';
import 'package:neurorite/auth/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        canvasColor: AppTheme.background,
        scaffoldBackgroundColor: AppTheme.background,
      ),
      home: const Auth(),
    );
  }
}
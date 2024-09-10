import 'package:flutter/material.dart';import 'dart:async';

import 'login.dart'; // Import your login page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Login(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {return const Scaffold( // LoadingScreen widget is defined here
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
  }
}
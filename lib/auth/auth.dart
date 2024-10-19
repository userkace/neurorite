import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:neurorite/screens/home.dart';
import 'package:neurorite/auth/login.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}

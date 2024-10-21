import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neurorite/views/home.dart';
import 'package:neurorite/auth/login.dart';
import 'package:neurorite/auth/verify.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data; // Get the user object
            if (user != null && user.emailVerified) {
              // User is signed in and verified
              return const Home();
            } else {
              // User is signed in but not verified
              return const Verify();
            }
          } else {
            // User is not signed in
            return const Login();
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'theme/app_theme.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Sign Up"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.00, 0.38, 0.80, 1.00],
              colors: [
                Color(0xAB00FFD1),
                Color(0xAB440088),
                Color(0xAB0C6582),
                Color(0xFF2E0A51),
              ],
            ),
          ),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(vertical: 65.0, horizontal: 40.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GradientText(
                    "Create an Account",

                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    gradient: LinearGradient(
                      stops: [0.61, 1.00],
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ]
                    )
                  ),
                  const SizedBox(height: 24.0),
                  Theme(
                    data: AppTheme.textFieldTheme,
                    child: const Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(labelText: "Email"),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(labelText: "Password"),
                          obscureText: true,
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(labelText: "Confirm Password"),
                          obscureText: true,
                        ),
                      ]
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Theme(
                    data: AppTheme.enterButtonTheme,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Home(),
                        ));
                      },
                      child: const Text("Sign up"),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Login(),
                      ));
                    },
                    child: const Text("Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}

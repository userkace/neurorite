import 'package:flutter/material.dart';

import 'home.dart';
import 'signup.dart';
import 'theme/app_theme.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Neurorite"),
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
            insetPadding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 40.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GradientText(
                    "Welcome Back!",

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
                          obscureText: true, // Hide password
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
                      child: const Text("Login"),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Signup(),
                      ));
                    },
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'theme/theme.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(" "),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          decoration: AppBackground.background,
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GradientText(
                    "Create account",

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
                  const SizedBox(height: 16.0),
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
                  const SizedBox(height: 32.0),
                  Theme(
                    data: AppTheme.enterButtonTheme,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Home(),
                        ));
                      },style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55), // Set the desired height
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                      child: const Text("Sign up"),
                    ),
                  ),
                  const SizedBox(height: 0.0),
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

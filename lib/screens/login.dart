import 'package:flutter/material.dart';
import 'home.dart';
import 'signup.dart';

import '../theme/theme.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppTheme.background),
        child: Stack(
          children: [
            const AppBackground(colored: true),
            Center(
                child: DialogBackground(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GradientText("Welcome Back",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              'Outfit', //GoogleFonts.getFont('Satisfy').fontFamily,
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ])),
                    const SizedBox(height: 32.0),
                    Theme(
                      data: AppTheme.textFieldTheme,
                      child: const Column(children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Email/Username",
                            labelStyle: TextStyle(
                              fontFamily:
                                  'Outfit', //GoogleFonts.getFont('Outfit').fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontFamily:
                                  'Outfit', //GoogleFonts.getFont('Outfit').fontFamily,
                            ),
                          ),
                          obscureText: true, // Hide password
                        ),
                      ]),
                    ),
                    const SizedBox(height: 30.0),
                    Theme(
                      data: AppTheme.enterButtonTheme,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Home(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                              55), // Set the desired height
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily:
                                'Outfit', //GoogleFonts.getFont('Outfit').fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Signup(),
                  ));
                },
                child: const Center(
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                      fontFamily:
                          'Outfit', //GoogleFonts.getFont('Outfit').fontFamily,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

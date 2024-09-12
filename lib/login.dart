import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'signup.dart';

import 'theme/theme.dart';

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
        decoration: AppBackground.background,
        child: Dialog(
          insetPadding:
              const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GradientText("Neurorite",
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.getFont('Satisfy').fontFamily,
                    ),
                    gradient: LinearGradient(stops: [
                      0.61,
                      1.00
                    ], colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ])),
                const SizedBox(height: 16.0),
                Theme(
                  data: AppTheme.textFieldTheme,
                  child: Column(children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.getFont('Outfit').fontFamily,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.getFont('Outfit').fontFamily,
                        ),
                      ),
                      obscureText: true, // Hide password
                    ),
                  ]),
                ),
                const SizedBox(height: 32.0),
                Theme(
                  data: AppTheme.enterButtonTheme,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Home(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size.fromHeight(55), // Set the desired height
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.getFont('Outfit').fontFamily,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 0.0),
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

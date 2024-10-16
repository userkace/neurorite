import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import '../theme/theme.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

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
                      GradientText(
                        "Create account",
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit'),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Theme(
                        data: AppTheme.textFieldTheme,
                        child: const Column(children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                              ),
                            ),
                            obscureText: true,
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
                            minimumSize: const Size.fromHeight(55),
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // "Login" TextButton at the bottom that moves up with the keyboard
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 5.0), // Slight padding from bottom
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Login(),
                    ));
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(fontFamily: 'Outfit'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

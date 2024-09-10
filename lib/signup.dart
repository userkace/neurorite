import 'package:flutter/material.dart';

import 'home.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(hintText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(hintText: "Confirm Password"),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Home(),
                ));
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

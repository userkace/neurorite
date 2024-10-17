import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:neurorite/theme/theme.dart';

void logOut(){
  FirebaseAuth.instance.signOut();
}

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true, // Extend body behind app bar
      appBar: AppBar(
        leading: IconButton(
          onPressed: () { Navigator.pop(context); },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile picture slot
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with your profile picture asset
            ),
            const SizedBox(height: 16),
            // Email
            const Text(
              'user@example.com', // Replace with user's email
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Outfit'
              ),
            ),
            const SizedBox(height: 16),

            // Logout button
            ElevatedButton(
              onPressed: () {
                logOut();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.tertiary, // Customize button color
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


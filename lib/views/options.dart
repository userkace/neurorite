import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:neurorite/theme/theme.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  final User? userCurrent = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> userDetail() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userCurrent!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true, // Extend body behind app bar
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: userDetail(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else if (snapshot.hasError) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    titleTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 22),
                    content: Text('${snapshot.error}'),
                    contentTextStyle: const TextStyle(color: Colors.white),
                    backgroundColor: const Color(0xFF0f0f0f),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                Map<String, dynamic>? user = snapshot.data!.data();
                int profile = user!['profile'];
                String path = 'assets/profiles/$profile.png';
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile picture slot
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust radius as needed
                        child: Image.asset(
                          path,
                          width: 100, // Adjust size as needed
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Email
                      Text(
                        user['email'], // Replace with user's email
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // Logout button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius as needed
                                ),
                                backgroundColor:
                                    Colors.white38, // Customize button color
                              ),
                              child: const HugeIcon(
                                icon: HugeIcons.strokeRoundedAiUser,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the radius as needed
                              ),
                              backgroundColor:
                                  AppTheme.tertiary, // Customize button color
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
              throw FirebaseAuthException(code: 'No Data');
            }));
  }
}

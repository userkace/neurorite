import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neurorite/auth/login.dart';
import 'package:neurorite/theme/theme.dart';
import 'package:neurorite/utils/error.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _ForgotState();
}

class _ForgotState extends State<Verify> {
  final TextEditingController _emailController = TextEditingController();

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
                isTextFieldFocused: false,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GradientText(
                        "Verify Email",
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
                      const Text('Check your Email for a verification link.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Outfit')),
                      const SizedBox(height: 30.0),
                      Theme(
                        data: AppTheme.enterButtonTheme,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const Login(),
                          )),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors
                                      .transparent; // or Colors.red, your preferred disabled color
                                } else {
                                  return AppTheme
                                      .tertiary; // your enabled color
                                }
                              },
                            ),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors
                                      .transparent; // Your preferred disabled color
                                } else {
                                  return Colors
                                      .white; // Use default foreground color
                                }
                              },
                            ),
                            minimumSize: WidgetStateProperty.all(
                                const Size.fromHeight(55)),
                            textStyle: WidgetStateProperty.all(
                                const TextStyle(fontSize: 18)),
                          ),
                          child: const Text(
                            "Confirm",
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
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 5.0), // Slight padding from bottom
                child: TextButton(
                    onPressed: () async {
                      try {
                        // Get the current user
                        User? user = FirebaseAuth.instance.currentUser;

                        // Check if the user is not null
                        if (user != null && !user.emailVerified) {
                          // Resend verification email
                          await user.sendEmailVerification();
                          ErrorDialog(title: 'Success', content: 'Check your inbox at ${user.email}.');
                        }
                      } catch (e) {
                        ErrorDialog(title: 'Error', content: 'Failed to resend verification email: $e');
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No verification email? ",
                          style: TextStyle(
                              fontFamily: 'Outfit', color: AppTheme.primary),
                        ),
                        Text(
                          "Resend",
                          style: TextStyle(
                              fontFamily: 'Outfit', color: Colors.white),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

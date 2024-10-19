import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neurorite/auth/login.dart';
import 'package:neurorite/theme/theme.dart';
import 'package:neurorite/models/error.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final TextEditingController _emailController = TextEditingController();

  bool _isButtonDisabled = false;
  Timer? _timer;

  final FocusNode _eFocusNode = FocusNode();
  bool _isTextFieldFocused = false; // State variable for focus

  @override
  void initState() {
    super.initState();
    _eFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _eFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      if (_eFocusNode.hasFocus) {
        _isTextFieldFocused = true;
      } else {
        _isTextFieldFocused = false;
      }
    });
  }

  Future<UserCredential?> forgot() async {
    if (_emailController.text.isEmpty) {
      Navigator.of(context).pop;
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(title: 'Error', content: 'Email cannot be empty.'),
      );
    } else {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text);
        await showDialog(
          context: context,
          builder: (context) => ErrorDialog(title: 'Success', content: 'Password reset has been sent to your inbox. ${_emailController.text}'),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop;
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(title: 'Error', content: 'Error with sign up: $e'),
        );
      }
    }
    return null;
  }

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
                isTextFieldFocused: _isTextFieldFocused,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GradientText(
                        "Forgot password",
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
                        child: Column(children: <Widget>[
                          TextField(
                            controller: _emailController,
                            focusNode: _eFocusNode,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 30.0),
                      Theme(
                        data: AppTheme.enterButtonTheme,
                        child: ElevatedButton(
                          onPressed: _isButtonDisabled
                              ? null // Disable button if flag is true
                              : () async {
                            setState(() {
                              _isButtonDisabled = true; // Disable button on click
                            });
                            await forgot();
                            // Re-enable button after a timeout
                            _timer = Timer(const Duration(seconds: 5), () { // 5-second timeout
                              setState(() {
                                _isButtonDisabled = false;
                              });
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.transparent; // or Colors.red, your preferred disabled color
                                } else {
                                  return AppTheme.tertiary; // your enabled color
                                }
                              },
                            ),
                            foregroundColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.transparent; // Your preferred disabled color
                                } else {
                                  return Colors.white; // Use default foreground color
                                }
                              },
                            ),
                            minimumSize: WidgetStateProperty.all(const Size.fromHeight(55)),
                            textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 18)),
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remember your password? ",
                          style: TextStyle(
                              fontFamily: 'Outfit', color: AppTheme.secondary),
                        ),
                        Text(
                          "Login",
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

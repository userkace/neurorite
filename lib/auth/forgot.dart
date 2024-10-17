import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neurorite/auth/login.dart';
import 'package:neurorite/theme/theme.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final TextEditingController _emailController = TextEditingController();

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
      Navigator.pop(context);
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
          content: const Text('Password cannot be empty.'),
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
    } else {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
            content: Text(
                'Password reset has been sent to your inbox. ${_emailController.text}'),
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
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
            content: Text('Error creating user: $e'),
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
                          onPressed: () async {
                            await forgot();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          child: const Text(
                            "Confirm",
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
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

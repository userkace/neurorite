import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neurorite/auth/signup.dart';
import 'package:neurorite/auth/verify.dart';
import 'package:neurorite/theme/theme.dart';
import 'package:neurorite/auth/auth.dart';
import 'package:neurorite/auth/forgot.dart';
import 'package:neurorite/utils/error.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _eFocusNode = FocusNode();
  final FocusNode _pFocusNode = FocusNode(); // FocusNode for text fields
  bool _isTextFieldFocused = false; // State variable for focus

  @override
  void initState() {
    super.initState();
    _eFocusNode.addListener(_onFocusChange);
    _pFocusNode.addListener(_onFocusChange); // Attach listener
  }

  @override
  void dispose() {
    _eFocusNode.dispose();
    _pFocusNode.dispose(); // Dispose FocusNode
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      if (_eFocusNode.hasFocus || _pFocusNode.hasFocus) {
        _isTextFieldFocused = true;
      } else {
        _isTextFieldFocused = false;
      }
    });
  }

  void logIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppTheme.tertiary)),
    );
    try {
      // Sign in the user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      // Check if the user's email is verified
      if (user != null && !user.emailVerified) {
        if (context.mounted) Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Verify(),
        ));
      } else {
        if (context.mounted) Navigator.pop(context);
        // Allow sign-in and navigate to Auth screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Auth(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) =>
            ErrorDialog(title: 'Error', content: 'Error with log in: ${e.code}'),
      );
    }
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
                    GradientText("Neurorite",
                        style: const TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              'Satisfy', //GoogleFonts.getFont('Satisfy').fontFamily,
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ])),
                    const SizedBox(height: 24.0),
                    Theme(
                      data: AppTheme.textFieldTheme,
                      child: Column(children: <Widget>[
                        TextField(
                          controller: _emailController,
                          focusNode: _eFocusNode,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontFamily:
                                  'Outfit', //GoogleFonts.getFont('Outfit').fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _passwordController,
                          focusNode: _pFocusNode,
                          decoration: const InputDecoration(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.white,
                            fontFamily: 'Outfit'),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const Forgot(),
                            ));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Theme(
                      data: AppTheme.enterButtonTheme,
                      child: ElevatedButton(
                        onPressed: () {
                          logIn();
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 5.0), // Slight padding from bottom
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Signup(),
                      ));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              fontFamily: 'Outfit', color: AppTheme.primary),
                        ),
                        Text(
                          "Sign up",
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

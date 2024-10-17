import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neurorite/auth/login.dart';
import 'package:neurorite/theme/theme.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final FocusNode _eFocusNode = FocusNode();
  final FocusNode _pFocusNode = FocusNode();
  final FocusNode _cFocusNode = FocusNode();// FocusNode for text fields
  bool _isTextFieldFocused = false; // State variable for focus

  @override
  void initState() {
    super.initState();
    _eFocusNode.addListener(_onFocusChange);
    _pFocusNode.addListener(_onFocusChange);
    _cFocusNode.addListener(_onFocusChange);// Attach listener
  }

  @override
  void dispose() {
    _eFocusNode.dispose();
    _pFocusNode.dispose();
    _cFocusNode.dispose();// Dispose FocusNode
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      if ((_eFocusNode.hasFocus || _pFocusNode.hasFocus) || _cFocusNode.hasFocus){
        _isTextFieldFocused = true;
      } else {
        _isTextFieldFocused = false;
      }
    });
  }

  Future<UserCredential?> signUp() async{
    showDialog(
        context: context,
        builder: (context) =>
            const Center(
                child: CircularProgressIndicator(color: AppTheme.tertiary)
            ),
    );
    if (_passwordController.text != _confirmController.text){
      Navigator.pop(context);
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
          content: const Text('Passwords are not the same.'),
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
    } else if (_passwordController.text.isEmpty) {
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
  } else if (_passwordController.text.length < 6) {
      Navigator.pop(context);
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
          content: const Text('Password must be at least 6 characters long.'),
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
      try{
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        Navigator.pop(context);
        return Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
      } on FirebaseAuthException catch (e){
        Navigator.pop(context);
        return showDialog(
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
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _passwordController,
                            focusNode: _pFocusNode,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                              ),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _confirmController,
                            focusNode: _cFocusNode,
                            decoration: const InputDecoration(
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
                          onPressed: () async {
                            await signUp();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Success'),
                                titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
                                content: const Text('Account created!'),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(fontFamily: 'Outfit', color: AppTheme.secondary),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(fontFamily: 'Outfit', color: Colors.white),
                      ),
                    ],
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

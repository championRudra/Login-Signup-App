// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class SignupWidget extends StatefulWidget {
  final VoidCallback onClickSignIn;

  const SignupWidget({
    super.key,
    required this.onClickSignIn,
  });

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            FlutterLogo(size: 120),
            SizedBox(height: 20),
            Text(
              'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter an valid email'
                      : null,
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            SizedBox(height: 4),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Enter min. 6 characters'
                  : null,
              controller: passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              onPressed: signUp,
              icon: Icon(Icons.arrow_forward, size: 32),
              label: Text(
                'Sign Up',
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickSignIn,
                    text: 'Log In',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

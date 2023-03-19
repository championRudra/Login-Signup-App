// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/screens/mobile_login_page.dart';

import '../utils/utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickSignUp;

  const LoginWidget({
    super.key,
    required this.onClickSignUp,
  });

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
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
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            // Email
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
            // Password
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
              onPressed: signIn,
              icon: Icon(Icons.lock_open_rounded, size: 32),
              label: Text(
                'Sign In',
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 24),
            GestureDetector(
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onTap: () => Navigator.of(context).pushNamed('/forgot-password'),
            ),
            SizedBox(
              height: 16,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                text: 'No account? ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickSignUp,
                    text: 'Sign Up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => MobileLoginPage(),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Login with Mobile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future signIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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

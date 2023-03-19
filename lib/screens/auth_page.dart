// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widgets/login_widget.dart';
import '../widgets/signup_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginWidget(onClickSignUp: toggel)
        : SignupWidget(onClickSignIn: toggel);
  }

  void toggel() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/forgot_password_page.dart';
import './screens/verify_email_page.dart';
import './screens/auth_page.dart';
import './utils/utils.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
          background: Colors.grey.shade800,
          brightness: Brightness.light,
          error: Colors.red,
          onError: Colors.white,
          onBackground: Colors.amber,
          onPrimary: Colors.white,
          onSecondary: Colors.orange,
          onSurface: Colors.purple,
          primary: Colors.teal,
          secondary: Colors.white,
          surface: Colors.pink,
        ),
      ),
      home: const MyHomePage(),
      routes: {
        ForgotPassword.routeName: (ctx) => ForgotPassword(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.7),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Text('Something went wrong'),
                  ElevatedButton(
                    onPressed: _signout,
                    child: Text('Sign out'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return VerifyEmailPage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}

Future<void> _signout() async {
  await FirebaseAuth.instance.signOut();
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/screens/auth_page.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage(this.user, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? auth = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Signed in as'),
              Text(
                auth!.phoneNumber != null
                    ? '${FirebaseAuth.instance.currentUser?.phoneNumber}'
                    : '${FirebaseAuth.instance.currentUser?.email}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed: () {
                  setState(() {
                    FirebaseAuth.instance.signOut();
                    debugPrint('Done');
                  });
                },
                icon: Icon(Icons.arrow_back),
                label: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

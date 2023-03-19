// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/screens/home_page.dart';
import '../utils/utils.dart';
import '../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  bool isCodeVerify = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '6 digit code',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                final navigator = Navigator.of(context);
                setState(() {
                  loading = true;
                });
                final crendital = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verificationCodeController.text,
                );
                try {
                  await auth.signInWithCredential(crendital);
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        FirebaseAuth.instance.currentUser,
                      ),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utils.showSnackBar(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

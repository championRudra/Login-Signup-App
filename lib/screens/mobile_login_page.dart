// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:login_signup/screens/verify_mobile_page.dart';

import '../utils/utils.dart';
import '../widgets/round_button.dart';
import 'home_page.dart';

class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({super.key});

  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {
  bool loading = false;
  bool isCodeVerify = false;
  final formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final _codeController = TextEditingController();
  // var countryCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    mobileController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.7),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 60),
              FlutterLogo(size: 120),
              SizedBox(height: 20),
              Text(
                'Login with Mobile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 10,
                maxLines: 1,
                validator: (val) => val!.length < 10
                    ? 'Number should be only 10 digits long.'
                    : null,
                // print(val.length);
                controller: mobileController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: 'Mobile No.',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                onPressed: sendOtp,
                icon: Icon(Icons.message_rounded),
                label: Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendOtp() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 ${mobileController.text.trim()}',
      timeout: Duration(seconds: 60),
      // phoneNumber: mobileController.text.trim(),
      verificationCompleted: (AuthCredential authCredential) {
        UserCredential result =
            _auth.signInWithCredential(authCredential) as UserCredential;

        User? user = result.user;
        FirebaseAuth.instance.signInWithCredential(authCredential).then(
          (result) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(user),
              ),
            );
          },
        ).catchError(
          (e) {
            print(e);
          },
        );
      },
      verificationFailed: (e) {
        print(e.toString());
        Utils.showSnackBar(e.toString());
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Give the code?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                  ),
                ],
              ),
              actions: <Widget>[
                RoundButton(
                  title: 'Verify',
                  loading: loading,
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    setState(() {
                      loading = true;
                    });
                    final crendital = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: _codeController.text,
                    );
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(crendital);
                      navigator.push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            FirebaseAuth.instance.currentUser,
                          ),
                        ),
                      );
                    } catch (e) {
                      Utils.showSnackBar(e.toString());
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                ),
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (e) {
        Utils.showSnackBar(e.toString());
      },
    );
  }
}



      

      

// ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:login_signup/screens/home_page.dart';
// import '../utils/utils.dart';
// class LoginScreen extends StatelessWidget {
//   final _phoneController = TextEditingController();
//   final _codeController = TextEditingController();
//   LoginScreen({super.key});
//   Future<bool> loginUser(String phone, BuildContext context) async {
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.all(32),
//         child: Form(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 "Login",
//                 style: TextStyle(
//                     color: Colors.lightBlue,
//                     fontSize: 36,
//                     fontWeight: FontWeight.w500),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                         borderSide: BorderSide(color: Colors.grey[200])),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                         borderSide: BorderSide(color: Colors.grey[300])),
//                     filled: true,
//                     fillColor: Colors.grey[100],
//                     hintText: "Mobile Number"),
//                 controller: _phoneController,
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Container(
//                 width: double.infinity,
//                 child: FlatButton(
//                   child: Text("LOGIN"),
//                   textColor: Colors.white,
//                   padding: EdgeInsets.all(16),
//                   onPressed: () {
//                     final phone = _phoneController.text.trim();
//                     loginUser(phone, context);
//                   },
//                   color: Colors.blue,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }

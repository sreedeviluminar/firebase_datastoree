import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'next_screen_phone_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDKX7A-Ixua4Xzq7vENdmKrr9l4t1SET_s",
    projectId: "animated-memory-377205",
    appId: '1:842448987777:android:b3913a3e6bd1525ded4f80',
    messagingSenderId: '',
    storageBucket: "animated-memory-377205.appspot.com",
  ));
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Phone Auth Example',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _verificationId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Login with OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _verifyPhoneNumber();
              },
              child: const Text('Send OTP'),
            ),
            const SizedBox(height: 16.0),
            PinFieldAutoFill(
              controller: _otpController,
              decoration: UnderlineDecoration(
                colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
              ),
              onCodeChanged: (String? value) {},
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _signInWithPhoneNumber();
              },
              child: const Text('Verify OTP'),
            ),

          ],
        ),
      ),
    );
  }


  Future<void> _verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          print("Verification completed automatically: $credential");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: $e");
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code sent to ${_phoneNumberController.text}");
          _verificationId = verificationId;

          // Comment the following line to disable automatic code retrieval
          // _autoRetrieveSMSCode(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Timeout reached: $verificationId");
        },
      );
    } catch (e) {
      print("Error verifying phone number: $e");
    }
  }

// Uncomment this method if you want to enable automatic code retrieval
// void _autoRetrieveSMSCode(String verificationId) async {
//   final code = await SmsAutoFill().getAppSignature;
//   print("SMS Code retrieved automatically: $code");
//   _otpController.text = code;
// }



  Future<void> _signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      print("User signed in: ${userCredential.user?.uid}");

      // Navigate to the new screen with the user ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userId: userCredential.user?.uid),
        ),
      );
    } catch (e) {
      print("Error signing in with OTP: $e");
    }
  }
}

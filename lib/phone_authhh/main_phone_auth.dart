import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
      home: PhoneAuthScreen(),
    );
  }
}

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();

  String _verificationId = "";

  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = "${_phoneNumberController.text}";
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve verification code and sign in (only on Android)
          await FirebaseAuth.instance.signInWithCredential(credential);
          print("Verification completed");
          _navigateToHomeScreen();
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store the verification ID for later use
          setState(() {
            _verificationId = verificationId;
          });
          print("Code Sent to $phoneNumber");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timed out
        },
      );
    } catch (e) {
      print("Error verifying phone number: $e");
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    String smsCode = _smsCodeController.text;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      print("Successfully signed in");
      _navigateToHomeScreen();
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyPhoneNumber,
              child: Text('Send Verification Code'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _smsCodeController,
              decoration: InputDecoration(labelText: 'Verification Code'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signInWithPhoneNumber,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

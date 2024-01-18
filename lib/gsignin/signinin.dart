import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_datastoree/gsignin/home.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  runApp(MaterialApp(home: SignInScreen()));
}

class SignInScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              UserCredential? userCredential = await _signInWithGoogle();
              if (userCredential != null) {
                print("Successfully signed in. Navigating to HomeScreen.");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(userCredential.user,),
                  ),
                );
              } else {
                print("Sign-in with Google failed.");
              }
            } catch (e) {
              print("Error during navigation: $e");
            }
          }, child: Text("Sign in with Google"),
        ),
      ),
    );
  }
}

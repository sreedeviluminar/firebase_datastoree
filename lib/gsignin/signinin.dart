import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async{
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
      home: SignInDemo(),
    );
  }
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> _handleSignIn() async {
    try {
      // Trigger Google Sign In
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      // If user canceled the sign-in, return null
      if (googleSignInAccount == null) {
        return null;
      }

      // Obtain GoogleSignInAuthentication and FirebaseUser
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);
      User? user = authResult.user;

      print("User signed in: ${user!.displayName}");

      return user;
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
  }

  void _handleSignOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    print("User signed out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                User? user = await _handleSignIn();
                if (user != null) {
                  // Successful sign-in, perform desired actions
                  print("Successful sign-in: ${user.displayName}");
                }
              },
              child: Text('Sign In with Google'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignOut,
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  User? user;

  HomeScreen(this.user) {
    print("Constructed HomeScreen for user: ${user?.displayName}");
  }
  @override
  Widget build(BuildContext context) {
    print("Building HomeScreen for user: ${user?.displayName}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Screen,'),
            Text(
              user?.displayName ?? 'User',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

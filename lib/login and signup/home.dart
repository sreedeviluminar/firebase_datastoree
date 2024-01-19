import 'package:flutter/material.dart';

class Homee extends StatelessWidget {
  const Homee({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome User",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown,
              fontSize: 20),
        ),
      ),
    );
  }
}

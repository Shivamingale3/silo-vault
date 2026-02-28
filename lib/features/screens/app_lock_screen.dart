import 'package:flutter/material.dart';

class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "App Lock Screen",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

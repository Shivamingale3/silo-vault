import 'package:flutter/material.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child:Text("App Lock Screen", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),);
  }
}
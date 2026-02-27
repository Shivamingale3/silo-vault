import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/security/app_security.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future<void> _checkPin() async {

    final exists = await AppSecurity.pinExists();

    if (!mounted) return;

    if (exists) {
      context.go(AppRoutes.appLock);
    } else {
      context.go(AppRoutes.pinSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
   return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

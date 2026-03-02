import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/security/app_security.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _isRoutingReady = false;
  String? _targetRoute;

  @override
  void initState() {
    super.initState();

    // Setup Progress Bar Animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 2s fake load
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateIfReady();
      }
    });

    _progressController.forward();
    _checkPin();
  }

  Future<void> _checkPin() async {
    final exists = await AppSecurity.pinExists();

    if (!mounted) return;

    _targetRoute = exists ? AppRoutes.appLock : AppRoutes.pinSetup;
    _isRoutingReady = true;

    // In case the auth check takes longer than the animation
    if (_progressController.isCompleted) {
      _navigateIfReady();
    }
  }

  void _navigateIfReady() {
    if (_isRoutingReady && _targetRoute != null && mounted) {
      context.go(_targetRoute!);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.black, // Dark background as requested
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 24), // Top spacer
              // Central Logo and Identity Section
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.15),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Icon Container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blueGrey.shade900,
                            width: 1,
                          ),
                          color: Colors.blueGrey.shade900.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        child: const Icon(
                          Icons.security, // or shield, lock_outline
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "VAULT",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 8,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "SECURED ENVIRONMENT",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                      color: Colors.blueGrey.shade400,
                    ),
                  ),
                ],
              ),

              // Bottom Progress and Status Section
              Column(
                children: [
                  // Progress Container
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Initializing secure modules...",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blueGrey.shade400,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                final percentage =
                                    (_progressAnimation.value * 100).toInt();
                                return Text(
                                  "$percentage%",
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Linear Progress
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _progressAnimation.value,
                                minHeight: 4,
                                backgroundColor: Colors.blueGrey.shade900,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Circular Loader and Text
                  Column(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified_user, size: 14, color: primary),
                          const SizedBox(width: 8),
                          Text(
                            "AES-256 BIT ENCRYPTION ACTIVE",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: Colors.blueGrey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Footer Identity
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fingerprint,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "BIOMETRIC READY",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

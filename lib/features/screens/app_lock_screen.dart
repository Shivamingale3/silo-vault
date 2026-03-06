import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silo_vault/constants/app_routes.dart';
import 'package:silo_vault/core/enums/security_enums.dart';
import 'package:silo_vault/core/security/secure_storage.dart';
import 'package:silo_vault/features/widgets/pin_unlock_view.dart';
import 'package:silo_vault/features/widgets/security_lockout_view.dart';
import 'package:silo_vault/security/app_security.dart';
import 'package:silo_vault/security/biometric_auth.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String pin = '';
  String? errorMessage;
  bool isProcessing = false;
  bool isLockedOut = false;
  bool isBiometricEnabled = false;
  int failedAttempts = 0;
  int maxFailedAttempts = 3;
  DateTime? lockoutUntil;
  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialCheck();
    });
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _initialCheck() async {
    if (!await AppSecurity.pinExists()) {
      if (!mounted) return;
      context.go(AppRoutes.pinSetup);
      return;
    }

    maxFailedAttempts = await SecureStorage.getMaxUnlockAttempts();
    failedAttempts = await SecureStorage.getFailedAttempts();

    // Check if currently locked out
    final lockoutTill = await SecureStorage.isLockedOut();
    if (lockoutTill.isAfter(DateTime.now())) {
      if (!mounted) return;
      _startLockout(lockoutTill);
      return;
    }

    // If there was a past lockout that has expired, clear it
    if (failedAttempts >= maxFailedAttempts) {
      await SecureStorage.clearLockout();
      failedAttempts = 0;
    }

    final biometricStatus = await SecureStorage.getBiometricStatus();

    if (!mounted) return;
    setState(() {
      isBiometricEnabled = biometricStatus;
    });

    if (biometricStatus) {
      await _attemptBiometric();
    }
  }

  void _startLockout(DateTime until) {
    setState(() {
      isLockedOut = true;
      lockoutUntil = until;
      errorMessage = null;
      pin = '';
    });

    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        _lockoutTimer?.cancel();
        return;
      }

      if (DateTime.now().isAfter(until)) {
        _lockoutTimer?.cancel();
        _endLockout();
      } else {
        setState(() {}); // Rebuild to update countdown
      }
    });
  }

  Future<void> _endLockout() async {
    await SecureStorage.clearLockout();
    if (!mounted) return;

    setState(() {
      isLockedOut = false;
      lockoutUntil = null;
      failedAttempts = 0;
      errorMessage = null;
      pin = '';
    });
  }

  Future<void> _triggerLockout() async {
    final until = DateTime.now().add(const Duration(minutes: 1));
    await SecureStorage.setLockoutTill(until);
    if (!mounted) return;
    _startLockout(until);
  }

  // Pure MM:SS format for the new design
  String _formatRemainingTimeLocked() {
    if (lockoutUntil == null) return "00:00";
    final remaining = lockoutUntil!.difference(DateTime.now());
    if (remaining.isNegative) return "00:00";
    final minutes = remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _attemptBiometric() async {
    final result = await BiometricAuth.authenticate();
    if (!mounted) return;

    switch (result) {
      case BiometricResult.success:
        await SecureStorage.clearLockout();
        if (!mounted) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.home);
        }
      case BiometricResult.cancelled:
      case BiometricResult.failed:
        setState(() {
          pin = '';
        });
        break;
    }
  }

  Future<void> _verifyPin(String inputPin) async {
    if (isProcessing || isLockedOut) return;

    setState(() {
      isProcessing = true;
      errorMessage = null;
    });

    try {
      final isValid = await AppSecurity.verifyPin(inputPin);

      if (!mounted) return;

      if (isValid) {
        await SecureStorage.clearLockout();
        if (!mounted) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.home);
        }
      } else {
        failedAttempts++;
        await SecureStorage.setFailedAttempts(failedAttempts);

        if (!mounted) return;

        if (failedAttempts >= maxFailedAttempts) {
          setState(() {
            isProcessing = false;
          });
          await _triggerLockout();
        } else {
          final remaining = maxFailedAttempts - failedAttempts;
          setState(() {
            isProcessing = false;
            errorMessage =
                "Incorrect PIN ($remaining ${remaining == 1 ? 'attempt' : 'attempts'} left)";
            pin = '';
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
        errorMessage = "Error verifying PIN";
        pin = '';
      });
    }
  }

  void _onDigitTap(String digit) {
    if (isProcessing || isLockedOut) return;
    setState(() {
      errorMessage = null;
      if (pin.length < 4) {
        pin += digit;
        if (pin.length == 4) {
          _verifyPin(pin);
        }
      }
    });
  }

  void _onBackspaceTap() {
    if (isProcessing || isLockedOut) return;
    setState(() {
      errorMessage = null;
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAmoled = theme.scaffoldBackgroundColor == Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Blurs mimicking the new design style
          if (!isLockedOut) ...[
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 300,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(
                    alpha: isAmoled ? 0.15 : 0.08,
                  ),
                ),
                child: BackdropFilter(
                  filter: ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.srcOver,
                  ),
                  child: Container(),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: -80,
              child: Container(
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade900.withValues(
                    alpha: isAmoled ? 0.2 : 0.1,
                  ),
                ),
              ),
            ),
          ],

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: isLockedOut
                        ? SecurityLockoutView(
                            remainingTime: _formatRemainingTimeLocked(),
                            onRequestEmergencyRecovery: () {},
                            onContactSupport: () {},
                          )
                        : PinUnlockView(
                            pin: pin,
                            errorMessage: errorMessage,
                            isProcessing: isProcessing,
                            isBiometricEnabled: isBiometricEnabled,
                            onDigitTap: _onDigitTap,
                            onBackspaceTap: _onBackspaceTap,
                            onBiometricTap: _attemptBiometric,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

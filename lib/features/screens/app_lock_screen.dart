import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/enums/security_enums.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/features/widgets/pin_action_buttons.dart';
import 'package:notes_vault/features/widgets/pin_input_section.dart';
import 'package:notes_vault/security/app_security.dart';
import 'package:notes_vault/security/biometric_auth.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String? errorMessage;
  bool hidePin = true;
  bool isProcessing = false;
  bool isLockedOut = false;
  int _pinInputKey = 0;
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

    if (!mounted) return;
    setState(() {});

    if (await SecureStorage.getBiometricStatus()) {
      await _attemptBiometric();
    }
  }

  void _startLockout(DateTime until) {
    setState(() {
      isLockedOut = true;
      lockoutUntil = until;
      errorMessage = null;
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
      _pinInputKey++;
    });
  }

  Future<void> _triggerLockout() async {
    final until = DateTime.now().add(const Duration(minutes: 1));
    await SecureStorage.setLockoutTill(until);
    if (!mounted) return;
    _startLockout(until);
  }

  String _formatRemainingTime() {
    if (lockoutUntil == null) return "";
    final remaining = lockoutUntil!.difference(DateTime.now());
    if (remaining.isNegative) return "";
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return "${minutes}m ${seconds.toString().padLeft(2, '0')}s";
  }

  Future<void> _attemptBiometric() async {
    final result = await BiometricAuth.authenticate();
    if (!mounted) return;

    switch (result) {
      case BiometricResult.success:
        await SecureStorage.clearLockout();
        if (!mounted) return;
        context.go(AppRoutes.home);
      case BiometricResult.cancelled:
      case BiometricResult.failed:
        setState(() {
          _pinInputKey++;
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
        context.go(AppRoutes.home);
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
            _pinInputKey++;
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
        errorMessage = "Error verifying PIN";
        _pinInputKey++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLockedOut ? Icons.lock : Icons.lock_outline,
              size: 48,
              color: isLockedOut ? Colors.red : null,
            ),
            const SizedBox(height: 16),
            Text(
              isLockedOut ? "Too Many Attempts" : "Unlock Notes Vault",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isLockedOut ? Colors.red : null,
              ),
            ),
            const SizedBox(height: 20),
            if (isLockedOut) ...[
              Text(
                "Try again in ${_formatRemainingTime()}",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your vault has been temporarily locked\ndue to too many failed attempts.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ] else ...[
              PinInputSection(
                key: ValueKey(_pinInputKey),
                step: 1,
                enabled: !isProcessing,
                obscurePin: hidePin,
                errorMessage: errorMessage,
                onPinComplete: _verifyPin,
              ),
              const SizedBox(height: 20),
              PinActionButtons(
                isProcessing: isProcessing,
                hidePin: hidePin,
                step: 1,
                onToggleVisibility: () {
                  setState(() {
                    hidePin = !hidePin;
                  });
                },
                onReset: () {},
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: isProcessing ? null : _attemptBiometric,
                icon: const Icon(Icons.fingerprint),
                label: const Text("Use Biometric"),
              ),
            ],
            if (isProcessing)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

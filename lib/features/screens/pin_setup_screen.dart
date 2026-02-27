import 'package:flutter/material.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/routing/app_router.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/features/widgets/pin_input.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String pin = '';
  String confirmPin = '';
  String? errorMessage;
  int step = 1;
  bool hidePin = true;
  bool enabled = true;
  bool enableBiometric = false;

  void resetPinSetup() {
    setState(() {
      enabled = true;
      pin = '';
      confirmPin = '';
      errorMessage = null;
      step = 1;
    });
  }

  void setPin() async {
    try {
      await SecureStorage.setAppPin(pin);
      setState(() {
        enabled = false;
        errorMessage = null;
      });
      appRouter.replace(AppRoutes.appLock);
      print("PIN set successfully: $pin");
    } catch (e) {
      print("Error setting PIN: ${e.toString()}");
    }
  }

  Widget buildPinInput() {
    return Column(
      children: [
        Text(
          step == 1 ? "Enter your PIN" : "Confirm your PIN",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        PinInput(
          key: ValueKey(step),
          enabled: enabled,
          onPinComplete: (value) {
            setState(() {
              if (step == 1) {
                pin = value;
                step = 2;
                errorMessage = null;
              } else {
                confirmPin = value;

                if (pin == confirmPin) {
                  enabled = false;
                  setPin();
                } else {
                  errorMessage = "PINs do not match";
                }
              }
            });
          },
          obscurePin: hidePin,
        ),
        if (errorMessage != null) ...[
          SizedBox(height: 10),
          Text(
            errorMessage!,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Set up your PIN",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildPinInput(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => {
                    setState(() {
                      hidePin = !hidePin;
                    }),
                  },
                  label: Text(hidePin ? "Show PIN" : "Hide"),
                  icon: Icon(hidePin ? Icons.visibility : Icons.visibility_off),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (step == 2) SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => {resetPinSetup()},
                  label: Text("Reset"),
                  icon: Icon(Icons.refresh),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Checkbox(value: value, onChanged: onChanged) for enabling biometrics
              ]
            )
          ],
        ),
      ),
    );
  }
}

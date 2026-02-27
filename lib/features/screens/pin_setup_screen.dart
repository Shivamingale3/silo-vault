import 'package:flutter/material.dart';
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
          onPinComplete: (value) {
            setState(() {
              if (step == 1) {
                pin = value;
                step = 2;
                errorMessage = null;
              } else {
                confirmPin = value;

                if (pin == confirmPin) {
                  errorMessage = null;

                  // success
                  print("PIN confirmed: $pin");
                } else {
                  errorMessage = "PINs do not match";

                  confirmPin = '';
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
            ElevatedButton.icon(
              onPressed: () => {
                setState(() {
                  hidePin = !hidePin;
                }),
              },
              label: Text(hidePin ? "Show PIN" : "Hide PIN"),
              icon: Icon(hidePin ? Icons.visibility : Icons.visibility_off),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

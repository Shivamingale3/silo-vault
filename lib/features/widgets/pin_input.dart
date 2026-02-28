import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInput extends StatefulWidget {
  final Function(String) onPinComplete;
  final bool obscurePin;
  final bool enabled;

  const PinInput({
    super.key,
    required this.onPinComplete,
    required this.obscurePin,
    required this.enabled,
  });

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  final controllers = List.generate(4, (index) => TextEditingController());
  final focusNodes = List.generate(4, (index) => FocusNode());
  @override
  void initState() {
    super.initState();

    // Wait until widget is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  String getPin() => controllers.map((c) => c.text).join();

  void handleInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index < controllers.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        widget.onPinComplete(getPin());
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  void handleBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  Widget buildBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        enabled: widget.enabled,
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        obscureText: widget.obscurePin,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          } else if (value.isNotEmpty && index < 3) {
            focusNodes[index + 1].requestFocus();
          }

          if (getPin().length == 4) {
            widget.onPinComplete(getPin());
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: List.generate(4, (index) => buildBox(index)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class PinInputBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscure;
  const PinInputBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.obscure,
  });

void _moveCursorToEnd() {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscure,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (_)=>_moveCursorToEnd(),
      ),
    );
  }
}

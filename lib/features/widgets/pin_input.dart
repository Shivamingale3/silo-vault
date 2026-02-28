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
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    setState(() {}); // Rebuild to update visual boxes

    if (text.length == 4 && !_hasSubmitted) {
      _hasSubmitted = true;
      // Unfocus to dismiss keyboard, then notify
      _focusNode.unfocus();
      widget.onPinComplete(text);
    } else if (text.length < 4) {
      _hasSubmitted = false;
    }
  }

  Widget _buildBox(int index) {
    final text = _controller.text;
    final isFilled = index < text.length;
    final isActive = index == text.length && _focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 50,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : isFilled
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.outline,
          width: isActive ? 2.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: isFilled
          ? Text(
              widget.obscurePin ? '•' : text[index],
              style: TextStyle(
                fontSize: widget.obscurePin ? 28 : 22,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled
              ? () {
                  if (_focusNode.hasFocus) {
                    _focusNode.unfocus();
                    Future.delayed(const Duration(milliseconds: 50), () {
                      if (mounted) _focusNode.requestFocus();
                    });
                  } else {
                    _focusNode.requestFocus();
                  }
                }
              : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Hidden text field that captures all input
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 1,
                  child: TextField(
                    enabled: widget.enabled,
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    autofocus: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // Visual display boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 5,
                      right: index == 3 ? 0 : 5,
                    ),
                    child: _buildBox(index),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

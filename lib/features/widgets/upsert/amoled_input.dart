import 'package:flutter/material.dart';

class AmoledInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool borderless;
  final TextStyle? style;
  final String? label;

  const AmoledInput({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.borderless = false,
    this.style,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultStyle = TextStyle(
      fontSize: 14,
      color: isDark ? Colors.white : Colors.black,
    );

    final inputDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
      contentPadding: borderless
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: !borderless,
      fillColor: isDark ? Colors.black : Colors.white,
      border: borderless
          ? InputBorder.none
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
      enabledBorder: borderless
          ? InputBorder.none
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
      focusedBorder: borderless
          ? InputBorder.none
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );

    Widget textField = TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: style ?? defaultStyle,
      decoration: inputDecoration,
    );

    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label!.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ),
          textField,
        ],
      );
    }

    return textField;
  }
}

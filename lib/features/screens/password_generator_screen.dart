import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int _length = 18;
  bool _useUppercase = true;
  bool _useLowercase = true;
  bool _useNumbers = true;
  bool _useSymbols = true;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const nums = '0123456789';
    const syms = '!@#\$%^*';

    String chars = '';
    List<String> guaranteedChars = [];
    final rnd = Random.secure();

    if (_useUppercase) {
      chars += upper;
      guaranteedChars.add(upper[rnd.nextInt(upper.length)]);
    }
    if (_useLowercase) {
      chars += lower;
      guaranteedChars.add(lower[rnd.nextInt(lower.length)]);
    }
    if (_useNumbers) {
      chars += nums;
      guaranteedChars.add(nums[rnd.nextInt(nums.length)]);
    }
    if (_useSymbols) {
      chars += syms;
      guaranteedChars.add(syms[rnd.nextInt(syms.length)]);
    }

    if (chars.isEmpty) {
      if (mounted) setState(() => _password = '');
      return;
    }

    int remainingLength = _length - guaranteedChars.length;
    if (remainingLength < 0) remainingLength = 0;

    List<String> passwordChars = [...guaranteedChars];
    for (int i = 0; i < remainingLength; i++) {
      passwordChars.add(chars[rnd.nextInt(chars.length)]);
    }

    passwordChars.shuffle(rnd);
    final newPassword = passwordChars.join().substring(0, _length);

    if (mounted) {
      setState(() {
        _password = newPassword;
      });
    }
  }

  void _copyPassword() {
    if (_password.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _password));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password copied to clipboard'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  double get _strengthScore {
    if (_password.isEmpty) return 0;
    double score = 0;
    if (_password.length >= 8) score += 1;
    if (_password.length >= 12) score += 1;
    if (_password.length >= 16) score += 1;
    if (_useUppercase) score += 1;
    if (_useLowercase) score += 1;
    if (_useNumbers) score += 1;
    if (_useSymbols) score += 1;
    return (score / 7).clamp(0.0, 1.0);
  }

  String get _strengthText {
    final score = _strengthScore;
    if (score == 0) return 'Weak';
    if (score < 0.4) return 'Weak';
    if (score < 0.7) return 'Good';
    if (score < 0.9) return 'Strong';
    return 'Very Strong';
  }

  Color get _strengthColor {
    final score = _strengthScore;
    if (score == 0) return Colors.red;
    if (score < 0.4) return Colors.orange;
    if (score < 0.7) return Colors.yellow.shade600;
    if (score < 0.9) return Colors.green.shade400;
    return const Color(0xFF10b981); // success color
  }

  void _updateToggle(void Function() update) {
    setState(() {
      update();
    });
    // Ensure we don't uncheck the last option
    if (!_useUppercase && !_useLowercase && !_useNumbers && !_useSymbols) {
      setState(() {
        _useLowercase = true; // fallback
      });
    }
    _generatePassword();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Dark mode forces background-dark
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: 120, // Leave room for fixed button
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPasswordDisplayBox(primaryColor),
                SizedBox(height: 24),
                _buildStrengthSection(),
                SizedBox(height: 32),
                _buildLengthControl(),
                SizedBox(height: 24),
                _buildOptionsList(primaryColor),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFooterAction(primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordDisplayBox(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            _password.isEmpty ? 'N/A' : _password.split('').join(' '),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 20,
              letterSpacing: 2.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _copyPassword,
                icon: Icon(Icons.copy, size: 16),
                label: Text(
                  'Copy',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              TextButton.icon(
                onPressed: _generatePassword,
                icon: Icon(Icons.refresh, size: 16),
                label: Text(
                  'Regenerate',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STRENGTH',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.54),
                letterSpacing: 1.5,
              ),
            ),
            Text(
              _strengthText.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _strengthColor,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final filledBlocks = (_strengthScore * 5).ceil();
            final isFilled = index < filledBlocks;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index == 4 ? 0 : 4),
                height: 4,
                decoration: BoxDecoration(
                  color: isFilled
                      ? _strengthColor
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLengthControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Password Length',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (_length > 4) {
                  setState(() => _length--);
                  _generatePassword();
                }
              },
              icon: Icon(
                Icons.remove,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                ),
                padding: const EdgeInsets.all(8),
              ),
            ),
            Container(
              width: 48,
              height: 40,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                '$_length',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_length < 64) {
                  setState(() => _length++);
                  _generatePassword();
                }
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                ),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionsList(Color primaryColor) {
    return Column(
      children: [
        _buildSwitchItem(
          'Uppercase Letters (A-Z)',
          _useUppercase,
          (val) => _updateToggle(() => _useUppercase = val),
          primaryColor,
        ),
        _buildSwitchItem(
          'Lowercase Letters (a-z)',
          _useLowercase,
          (val) => _updateToggle(() => _useLowercase = val),
          primaryColor,
        ),
        _buildSwitchItem(
          'Numbers (0-9)',
          _useNumbers,
          (val) => _updateToggle(() => _useNumbers = val),
          primaryColor,
        ),
        _buildSwitchItem(
          'Symbols (!@#\$%^*)',
          _useSymbols,
          (val) => _updateToggle(() => _useSymbols = val),
          primaryColor,
        ),
      ],
    );
  }

  Widget _buildSwitchItem(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    Color activeColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Theme.of(context).colorScheme.onSurface,
            activeTrackColor: activeColor,
            inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
            inactiveTrackColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.12),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterAction(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          _copyPassword();
          Navigator.of(context).pop(_password);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Use This Password',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

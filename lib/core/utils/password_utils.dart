import 'package:notes_vault/core/enums/db_enums.dart';

class PasswordUtils {
  /// Calculates password strength based on entropy factors.
  static PasswordStrength calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length scoring
    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    if (password.length >= 14) score++;
    if (password.length >= 18) score++;

    // Character variety scoring
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(
      r'[!@#$%^&*()_+\-=\[\]{};:\x27"\\|,.<>/?`~]',
    ).hasMatch(password)) {
      score++;
    }

    // Penalty for common patterns
    if (RegExp(r'(.)\1{2,}').hasMatch(password)) score--; // repeated chars
    if (RegExp(r'^[a-zA-Z]+$').hasMatch(password)) score--; // letters only

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score <= 6) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  /// Returns a normalized 0.0–1.0 score for UI indicators.
  static double strengthScore(String password) {
    switch (calculateStrength(password)) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  /// Returns human-readable label for the strength.
  static String strengthLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }
}

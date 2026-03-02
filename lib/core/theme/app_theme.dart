import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF1152D4);
  static const Color bgLight = Color(0xFFF6F6F8);
  static const Color textLight = Color(0xFF0F172A); // slate-900

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF1152D4);
  static const Color bgDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textDark = Color(0xFFF1F5F9); // slate-100

  // Amoled Theme Colors
  static const Color primaryAmoled = Color(0xFF1152D4);
  static const Color bgAmoled = Color(0xFF000000);
  static const Color cardAmoled = Color(0xFF121212);
  static const Color textAmoled = Color(0xFFFFFFFF); // white

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        surface: bgLight,
        onSurface: textLight,
      ),
      scaffoldBackgroundColor: bgLight,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).apply(bodyColor: textLight, displayColor: textLight),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        surface: bgDark,
        onSurface: textDark,
        surfaceContainer: cardDark,
      ),
      scaffoldBackgroundColor: bgDark,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: textDark, displayColor: textDark),
    );
  }

  static ThemeData amoledTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryAmoled,
        surface: bgAmoled,
        onSurface: textAmoled,
        surfaceContainer: cardAmoled,
      ),
      scaffoldBackgroundColor: bgAmoled,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: textAmoled, displayColor: textAmoled),
    );
  }
}

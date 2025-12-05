
// lib/theme/consorcio_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsorcioTheme {
  static const Color primary = Color(0xFF003058); // Azul
  static const Color accentGreen = Color(0xFF84BD00); // Verde marca
  static const Color accentGreenLight = Color(0xFF9AD06D);

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: accentGreen,
      ),
      textTheme: GoogleFonts.openSansTextTheme(base.textTheme).copyWith(
        displayMedium: GoogleFonts.openSans(
          fontWeight: FontWeight.w700, color: primary, fontSize: 32,
        ),
        titleLarge: GoogleFonts.openSans(
          fontWeight: FontWeight.w600, color: primary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: primary,
        titleTextStyle: GoogleFonts.openSans(
          fontSize: 18, fontWeight: FontWeight.w600, color: primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        labelStyle: GoogleFonts.openSans(color: Colors.grey[700]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: GoogleFonts.openSans(
            fontWeight: FontWeight.w600, letterSpacing: .3,
          ),
        ),
      ),
    );
  }
}

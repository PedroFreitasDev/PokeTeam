import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFCC0000);
  static const Color darkRed = Color(0xFF8B0000);
  static const Color gold = Color(0xFFFFD700);
  static const Color background = Color(0xFFF5F0E8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF222222);
  static const Color textMuted = Color(0xFF555555);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        surface: background,
        onSurface: textDark,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.pressStart2pTextTheme().copyWith(
        bodyMedium: GoogleFonts.vt323(fontSize: 18, color: textMuted),
        bodySmall: GoogleFonts.vt323(fontSize: 16, color: textMuted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.pressStart2p(
          fontSize: 14,
          color: Colors.white,
          letterSpacing: 1,
        ),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.pressStart2p(fontSize: 9),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          side: const BorderSide(color: textDark, width: 3),
          elevation: 0,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primaryRed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xAAFFFFFF),
      ),
    );
  }
}

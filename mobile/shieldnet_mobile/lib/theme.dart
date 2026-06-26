import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShieldNetTheme {
  static const Color bg        = Color(0xFF0A0E16);
  static const Color card      = Color(0xFF141B2E);
  static const Color purple    = Color(0xFF9B8CF5);
  static const Color blue      = Color(0xFF4A7DFF);
  static const Color textPrime = Color(0xFFEDF2FF);
  static const Color textMuted = Color(0xFF8899BB);
  static const Color border    = Color(0x1AFFFFFF);
  static const Color success   = Color(0xFF00C49A);
  static const Color danger    = Color(0xFFE24B4A);

  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: purple,
      secondary: blue,
      surface: card,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        color: textPrime, fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        color: textPrime, fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.inter(color: textMuted),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrime),
    ),
  );
}
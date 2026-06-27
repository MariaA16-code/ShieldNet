import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ShieldNet Mobile — visual identity.
///
/// Palette matches the web app exactly (background, cardColor, purple,
/// blue, success) so the product family reads as one thing across
/// platforms. Typography (Lexend for headlines, Inter for body) is
/// mobile's own signature touch.
class AppTheme {
  // ---------------------------------------------------------------------
  // Core palette — matches web app
  // ---------------------------------------------------------------------
  static const Color background = Color(0xFF0A0E16);
  static const Color cardColor = Color(0xFF141B2E);
  static const Color purple = Color(0xFF9B8CF5);
  static const Color blue = Color(0xFF4A7DFF);
  static const Color success = Color(0xFF00C9A7);
  static const Color warning = Color(0xFFFFB347);
  static const Color error = Color(0xFFFF6B6B);

  static const Color textPrimary = Color(0xFFEDEFF5);
  static const Color textSecondary = Color(0xFF8B92A8);
  static const Color border = Color(0xFF232B3D);

  /// Used sparingly — primary buttons and active states only.
  /// Not used as a decorative background gradient.
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple, blue],
  );

  // ---------------------------------------------------------------------
  // ThemeData
  // ---------------------------------------------------------------------
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,

      colorScheme: const ColorScheme.dark(
        surface: background,
        primary: purple,
        secondary: blue,
        error: error,
        onSurface: textPrimary,
      ),

      textTheme: TextTheme(
        // Eyebrow labels — e.g. "ANONYMOUS · ENCRYPTED · FREE"
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: purple,
          letterSpacing: 1.6,
        ),
        headlineLarge: GoogleFonts.lexend(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
          height: 1.15,
        ),
        headlineMedium: GoogleFonts.lexend(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          height: 1.2,
        ),
        titleLarge: GoogleFonts.lexend(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: purple,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: purple,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: border, width: 1.2),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: purple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
      ),

      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: purple,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }
}
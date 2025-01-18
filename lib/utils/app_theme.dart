import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Violet
  static const Color accentColor = Color(0xFFEC4899); // Pink
  static const Color backgroundColor = Color(0xFF0F172A); // Slate 900
  static const Color surfaceColor = Color(0xFF1E293B); // Slate 800
  static const Color textColor = Color(0xFFF8FAFC); // Slate 50

  // Gradyan renkler
  static const Color gradientStart = Color(0xFF6366F1); // Indigo
  static const Color gradientMiddle = Color(0xFF8B5CF6); // Violet
  static const Color gradientEnd = Color(0xFFEC4899); // Pink

  // Vurgu renkleri
  static const Color successColor = Color(0xFF34D399); // Emerald
  static const Color warningColor = Color(0xFFFBBF24); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red

  static const Color shadowColor = Color(0x55000000);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      surface: surfaceColor,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: textColor),
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor.withAlpha(230),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: accentColor,
      size: 24,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF334155), // Slate 700
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF334155), // Slate 700
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      labelStyle: GoogleFonts.roboto(
        color: textColor.withAlpha(180),
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
    ),
  );
}

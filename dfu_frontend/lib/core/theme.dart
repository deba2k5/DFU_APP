import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Glassmorphism Colors
  static const Color glassWhite = Color(0x66FFFFFF);
  static const Color glassDeep = Color(0x801E293B);
  static const Color primaryCyan = Color(0xFF00D2FF);
  static const Color mintGreen = Color(0xFF92FE9D);
  static const Color backgroundDark = Color(0xFF0B0E14);
  static const Color backgroundLight = Color(0xFFF0F4F8);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    primaryColor: primaryCyan,
    colorScheme: const ColorScheme.dark(
      primary: primaryCyan,
      secondary: mintGreen,
      surface: glassDeep,
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardThemeData(
      color: glassDeep,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    primaryColor: primaryCyan,
    colorScheme: const ColorScheme.light(
      primary: primaryCyan,
      secondary: mintGreen,
      surface: glassWhite,
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    cardTheme: CardThemeData(
      color: glassWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3EBACE);
  static const Color secondaryColor = Color(0xFF1A1A1A);
  static const Color accentColor = Color(0xFFFFD700);
  static const Color scaffoldBackgroundColor = Color(0xFFF3F5F7);
  static const Color cardColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: scaffoldBackgroundColor,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: secondaryColor,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 16,
          color: secondaryColor.withAlpha(204), // replaced withOpacity(0.8)
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: secondaryColor),
      ),
    );
  }
}

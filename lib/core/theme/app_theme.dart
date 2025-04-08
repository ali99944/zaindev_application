import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static const double _lowRadius = 6.0; // Low border radius
  static const double _lowPadding = 12.0; // Example low padding value

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Recommended for modern Flutter apps
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primary, // Can adjust if needed
        onPrimary: AppColors.black, // Text on primary buttons
        surface: AppColors.white, // Card backgrounds, dialogs etc.
        onSurface: AppColors.black, // Text on surface
        background: AppColors.background,
        onBackground: AppColors.black, // Text on background
        error: Colors.redAccent,
        onError: AppColors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.black, // Back button, title color
        elevation: 0, // No shadow
        titleTextStyle: GoogleFonts.tajawal( // Default Arabic font
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      textTheme: TextTheme(
        // Define default text styles using Google Fonts
        displayLarge: GoogleFonts.tajawal(color: AppColors.black),
        displayMedium: GoogleFonts.tajawal(color: AppColors.black),
        displaySmall: GoogleFonts.tajawal(color: AppColors.black),
        headlineLarge: GoogleFonts.tajawal(color: AppColors.black, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.tajawal(color: AppColors.black, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.tajawal(color: AppColors.black, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.tajawal(color: AppColors.black, fontWeight: FontWeight.bold),
        titleMedium: GoogleFonts.tajawal(color: AppColors.black),
        titleSmall: GoogleFonts.tajawal(color: AppColors.black),
        bodyLarge: GoogleFonts.tajawal(color: AppColors.black, fontSize: 16), // Default body text
        bodyMedium: GoogleFonts.tajawal(color: AppColors.black, fontSize: 14),
        bodySmall: GoogleFonts.tajawal(color: AppColors.grey, fontSize: 12),
        labelLarge: GoogleFonts.tajawal(color: AppColors.black, fontWeight: FontWeight.bold), // Button text
        labelMedium: GoogleFonts.tajawal(color: AppColors.black),
        labelSmall: GoogleFonts.tajawal(color: AppColors.black),
      ).apply(
        // Apply Poppins as fallback/English font if needed, otherwise Tajawal dominates
         fontFamily: GoogleFonts.poppins().fontFamily, // English Font
         bodyColor: AppColors.black,
         displayColor: AppColors.black,
      ),

      // Button Theme according to specs
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.black, // Text color
          elevation: 0, // No shadow
          shadowColor: Colors.transparent, // Ensure no shadow color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_lowRadius),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: _lowPadding,
            horizontal: _lowPadding * 2, // More horizontal padding usually
          ),
          textStyle: GoogleFonts.tajawal( // Explicitly set button font if needed
             fontWeight: FontWeight.w700,
             fontSize: 16,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary, // Text color for text buttons
           textStyle: GoogleFonts.tajawal( // Explicitly set button font if needed
             fontWeight: FontWeight.w600, // Slightly less bold
             fontSize: 14,
          ),
        )
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white, // Or a very light grey
        contentPadding: const EdgeInsets.symmetric(vertical: _lowPadding, horizontal: _lowPadding),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(_lowRadius),
           borderSide: BorderSide(color: AppColors.lightGrey.withOpacity(0.5)),
         ),
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(_lowRadius),
           borderSide: BorderSide(color: AppColors.lightGrey.withOpacity(0.5)),
         ),
         focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(_lowRadius),
           borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
         ),
         hintStyle: GoogleFonts.tajawal(color: AppColors.grey, fontSize: 14),
      ),

      // Card Theme (used for service boxes maybe)
      cardTheme: CardTheme(
         elevation: 0,
         color: AppColors.white, // Default card background
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(_lowRadius),
           // Optional: Add a light border if needed for definition without shadow
           // side: BorderSide(color: AppColors.lightGrey.withOpacity(0.5), width: 1),
         ),
      ),
    );
  }

  // Define darkTheme later if needed
  // static ThemeData get darkTheme { ... }
}
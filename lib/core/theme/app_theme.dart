import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

const double _lowPadding = 8.0;
const double _mediumPadding = 16.0;
const double _lowRadius = 4.0; // Low radius as requested

ThemeData createTheme({required Brightness brightness, required String languageCode}) {
  final baseTextTheme = brightness == Brightness.light ? Typography.blackMountainView : Typography.whiteMountainView;
  final textTheme = languageCode == 'ar'
      ? GoogleFonts.cairoTextTheme(baseTextTheme)
      : GoogleFonts.latoTextTheme(baseTextTheme); // Example English font

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textOnSecondary,
    error: AppColors.accent,
    onError: AppColors.textOnAccent,
    background: AppColors.background,
    onBackground: AppColors.textPrimary,
    surface: AppColors.background,
    onSurface: AppColors.textPrimary,
  );

  return ThemeData(
    brightness: brightness,
    colorScheme: colorScheme,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
     ),
    appBarTheme: AppBarTheme(
      elevation: 0, // No shadow
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary, // Title/icon color
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: AppColors.textOnPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0, // No shadow
        padding: const EdgeInsets.symmetric(
            vertical: _mediumPadding, horizontal: _mediumPadding * 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_lowRadius), // Low radius
        ),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
       style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
         padding: const EdgeInsets.symmetric(
            vertical: _mediumPadding, horizontal: _mediumPadding * 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_lowRadius), // Low radius
        ),
         textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
         padding: const EdgeInsets.symmetric(
            vertical: _lowPadding, horizontal: _mediumPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_lowRadius), // Low radius
        ),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primary.withOpacity(0.05), // Slight fill
      contentPadding: const EdgeInsets.symmetric(
          vertical: _mediumPadding, horizontal: _mediumPadding),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_lowRadius), // Low radius
        borderSide: BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_lowRadius),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_lowRadius),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_lowRadius),
        borderSide: const BorderSide(color: AppColors.accent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_lowRadius),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      labelStyle: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
      hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary.withOpacity(0.7)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    cardTheme: CardTheme(
      elevation: 0, // No shadow for cards generally
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_lowRadius),
          side: BorderSide(color: AppColors.divider.withOpacity(0.5)),
      ),
      margin: EdgeInsets.zero, // Control margin where used
    ),
     // Apply low padding generally via visual density or specific padding widgets
    visualDensity: VisualDensity.compact, // Can make things slightly tighter
    useMaterial3: true,
  );
}
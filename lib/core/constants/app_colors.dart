import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF9A01); // Amber/Orange
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF808080); // Example Grey
  static const Color lightGrey = Color(0xFFD3D3D3); // Lighter Grey
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9FBFA);

  // Lighter shade for service boxes etc. Adjust opacity/mixing as needed.
  static Color lightPrimary = primary.withOpacity(0.1);

  // Dark Mode (Optional placeholders for now)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
}
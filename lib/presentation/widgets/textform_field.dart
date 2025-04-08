import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart'; // Assuming AppColors is here

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIconData;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool readOnly;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIconData,
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Decoration will derive most styles from InputDecorationTheme in AppTheme
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      // Style text input based on theme's textTheme
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        // Theme provides: filled, fillColor, border, enabledBorder, focusedBorder, hintStyle, contentPadding
        labelText: labelText,
        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle ??
                   Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey), // Ensure label style
        hintText: hintText,
        prefixIcon: prefixIconData != null
            ? Icon(prefixIconData, color: AppColors.grey, size: 22) // Standardize prefix icon style
            : null,
        suffixIcon: suffixIcon,
        // Override error style if needed, otherwise uses theme default
        // errorStyle: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
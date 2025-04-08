import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final double? minWidth; // Optional minimum width
  final Widget? leadingIcon; // Optional icon before text

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.minWidth,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Button style will be derived from the ElevatedButtonThemeData in AppTheme
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: minWidth != null ? Size(minWidth!, 48) : null, // Ensure decent height
        // Theme already defines:
        // backgroundColor: AppColors.primary,
        // foregroundColor: AppColors.black,
        // elevation: 0,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        // padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24, // Consistent size for loader
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.black, // Loader color on amber button
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min, // Take minimum space needed
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  const SizedBox(width: 8), // Space between icon and text
                ],
                Text(text), // Text style comes from theme
              ],
            ),
    );
  }
}
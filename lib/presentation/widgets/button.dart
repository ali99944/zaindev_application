import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

enum ZainButtonVariant { primary, secondary, destructive }

class ZainButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ZainButtonVariant variant;
  final bool isLoading;
  final double? width;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? color;

  const ZainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ZainButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.icon,
    this.backgroundColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 44, // Compact size
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? _getBackgroundColor(context),
          foregroundColor: _getForegroundColor(context),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Low radius
          ),
          elevation: 0, // No shadow
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: color ?? Colors.black,),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color ?? _getTextColor(context),
                        ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (variant) {
      case ZainButtonVariant.primary:
        return AppColors.primary;
      case ZainButtonVariant.secondary:
        return AppColors.lightPrimary;
      case ZainButtonVariant.destructive:
        return Colors.red.shade500;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    switch (variant) {
      case ZainButtonVariant.primary:
        return AppColors.primary;
      case ZainButtonVariant.secondary:
        return AppColors.primary;
      case ZainButtonVariant.destructive:
        return Colors.red.shade500;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (variant) {
      case ZainButtonVariant.primary:
        return AppColors.black;
      case ZainButtonVariant.secondary:
        return AppColors.black;
      case ZainButtonVariant.destructive:
        return Colors.white;
    }
  }
}

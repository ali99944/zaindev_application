import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing; // For things like chevron, current language, etc.
  final Color? iconColor; // Optional color override for icon
  final Color? textColor; // Optional color override for text (e.g., for logout)

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0), // Adjust padding as needed
        child: Row(
          children: [
            // Icon on the right for RTL, left for LTR
            if (isRtl) ...[
              const Spacer(), // Push content to the left
              if (trailing != null) trailing!,
              if (trailing != null) const SizedBox(width: 16),
              Text(
                title,
                style: textTheme.bodyLarge?.copyWith(color: textColor ?? AppColors.black),
              ),
              const SizedBox(width: 16),
               Icon(
                icon,
                color: iconColor ?? AppColors.grey, // Default to grey
                size: 24,
              ),
            ]
            // Icon on the left for LTR (Standard Material layout)
            else ...[
               Icon(
                 icon,
                 color: iconColor ?? AppColors.grey, // Default to grey
                 size: 24,
               ),
               const SizedBox(width: 16),
               Expanded( // Allow title text to expand
                 child: Text(
                   title,
                   style: textTheme.bodyLarge?.copyWith(color: textColor ?? AppColors.black),
                 ),
               ),
               if (trailing != null) const SizedBox(width: 16),
               if (trailing != null) trailing!,
            ]
          ],
        ),
      ),
    );
  }
}
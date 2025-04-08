import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ServiceCategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  const ServiceCategoryItem({
    super.key,
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Use a fixed low radius value from theme or define here temporarily
    const double lowRadius = 6.0;
    const double itemPadding = 12.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(lowRadius), // Match container radius
      child: Container(
        padding: const EdgeInsets.all(itemPadding),
        decoration: BoxDecoration(
          // Lighter shade of primary for background
          color: AppColors.lightPrimary,
          borderRadius: BorderRadius.circular(lowRadius),
          // Optional: Add a subtle border if needed for definition without shadow
          // border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary, // Use primary color for the icon
              size: 36.0, // Adjust size as needed
            ),
            const SizedBox(height: 8.0),
            Text(
              name,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w500, // Medium weight for clarity
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Allow for slightly longer names
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
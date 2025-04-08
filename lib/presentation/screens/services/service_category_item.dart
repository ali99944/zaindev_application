import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ServiceCategoryItem extends StatelessWidget {
  final IconData? icon; // Make icon optional if using images
  final String? imageUrl; // Add imageUrl
  final String name;
  final VoidCallback onTap;
  final double itemWidth; // Control width for horizontal list

  const ServiceCategoryItem({
    super.key,
    this.icon,
    this.imageUrl,
    required this.name,
    required this.onTap,
    this.itemWidth = 100.0, // Default width
  }) : assert(icon != null || imageUrl != null, 'Must provide either an icon or an imageUrl');


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const double lowRadius = 12.0; // Slightly higher radius for this style
    const double internalPadding = 8.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(lowRadius),
      child: Container(
        width: itemWidth,
        padding: const EdgeInsets.all(internalPadding),
        decoration: BoxDecoration(
          // Use white or very light grey background like reference
          color: AppColors.white,
          borderRadius: BorderRadius.circular(lowRadius),
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5), width: 1), // Subtle border
          // No shadow as per theme
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display Image or Icon
            SizedBox(
              height: 40, // Fixed height for icon/image container
              width: 40,
              child: imageUrl != null
                  ? ClipRRect( // Clip image if needed
                      borderRadius: BorderRadius.circular(lowRadius / 2),
                      child: Image.network( // Or Image.asset if local
                        imageUrl!,
                        fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, color: AppColors.grey), // Placeholder on error
                         loadingBuilder:(context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                          },
                      ),
                  )
                  : Icon(
                       icon,
                       color: AppColors.primary, // Icon color
                       size: 30.0,
                     ),
            ),
            const SizedBox(height: 8.0),
            Text(
              name,
              style: textTheme.bodyMedium?.copyWith( // Slightly smaller text for this style
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add dependency: flutter pub add intl

import '../../../core/constants/app_colors.dart';
import 'bookings_screen.dart'; // Import model and enum

class BookingListItem extends StatelessWidget {
  final BookingInfo booking;
  final VoidCallback onTap;

  const BookingListItem({
    super.key,
    required this.booking,
    required this.onTap,
  });

   // Helper to get status color and text
   Map<String, dynamic> _getStatusStyle(BookingStatus status) {
     switch (status) {
       case BookingStatus.upcoming:
         return {'text': 'قادم', 'color': Colors.blue.shade700, 'icon': Icons.update};
       case BookingStatus.completed:
         return {'text': 'مكتمل', 'color': Colors.green.shade700, 'icon': Icons.check_circle_outline};
       case BookingStatus.cancelled:
         return {'text': 'ملغي', 'color': Colors.red.shade700, 'icon': Icons.cancel_outlined};
     }
   }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statusStyle = _getStatusStyle(booking.status);
    final formattedDate = DateFormat('EEE, d MMM yyyy').format(booking.dateTime); // Format date
    final formattedTime = DateFormat('h:mm a').format(booking.dateTime); // Format time

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5), width: 1.0),
          // No shadow
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Expanded(
                   child: Text(
                    booking.serviceName,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                                   ),
                 ),
                 const SizedBox(width: 10),
                // Status Chip
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                   decoration: BoxDecoration(
                     color: (statusStyle['color'] as Color).withOpacity(0.1),
                     borderRadius: BorderRadius.circular(4),
                   ),
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Icon(statusStyle['icon'] as IconData, color: statusStyle['color'] as Color, size: 14),
                       const SizedBox(width: 4),
                       Text(
                         statusStyle['text'] as String,
                         style: textTheme.labelSmall?.copyWith(color: statusStyle['color'] as Color, fontWeight: FontWeight.bold)
                        ),
                     ],
                   ),
                 ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.grey),
                const SizedBox(width: 6),
                Text('$formattedDate - $formattedTime', style: textTheme.bodyMedium?.copyWith(color: AppColors.grey)),
              ],
            ),
            // Optional: Show provider info if available
            if (booking.providerName != null) ...[
               const Divider(height: 16, thickness: 0.2),
               Row(
                 children: [
                   CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                      backgroundImage: booking.providerAvatarUrl != null ? NetworkImage(booking.providerAvatarUrl!) : null,
                      child: booking.providerAvatarUrl == null ? const Icon(Icons.person, size: 12, color: AppColors.grey) : null,
                   ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.providerName!,
                         style: textTheme.bodyMedium,
                         overflow: TextOverflow.ellipsis,
                      ),
                    ),
                 ],
               )
            ]
          ],
        ),
      ),
    );
  }
}
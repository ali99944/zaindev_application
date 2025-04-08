import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/primary_button.dart';
import 'bookings_screen.dart'; // Import model/enum

// Provider to fetch specific booking details by ID (replace with actual logic)
final bookingDetailsProvider = FutureProvider.autoDispose.family<BookingInfo?, String>((ref, bookingId) async {
  // Simulate fetching booking details
  await Future.delayed(const Duration(milliseconds: 500));
  final allBookings = ref.read(bookingsProvider); // Use the dummy list for now
  try {
    return allBookings.firstWhere((b) => b.id == bookingId);
  } catch (e) {
    return null; // Booking not found
  }
});

class BookingDetailsScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  // Helper to get status style (can be moved to a common place)
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
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingDetailsAsync = ref.watch(bookingDetailsProvider(bookingId));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
      ),
      body: bookingDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('خطأ في تحميل التفاصيل: $error')),
        data: (booking) {
          if (booking == null) {
            return const Center(child: Text('لم يتم العثور على الطلب.'));
          }

          final statusStyle = _getStatusStyle(booking.status);
          final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(booking.dateTime);
          final formattedTime = DateFormat('h:mm a').format(booking.dateTime);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Service Name & Status ---
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Expanded(
                       child: Text(booking.serviceName, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                     ),
                      Container(
                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                       decoration: BoxDecoration(
                         color: (statusStyle['color'] as Color).withOpacity(0.1),
                         borderRadius: BorderRadius.circular(4),
                       ),
                       child: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Icon(statusStyle['icon'] as IconData, color: statusStyle['color'] as Color, size: 16),
                           const SizedBox(width: 5),
                           Text(
                             statusStyle['text'] as String,
                             style: textTheme.bodyMedium?.copyWith(color: statusStyle['color'] as Color, fontWeight: FontWeight.bold)
                           ),
                         ],
                       ),
                     ),
                  ],
                ),
                const Divider(height: 24),

                // --- Date & Time ---
                _buildDetailRow(
                  context: context,
                  icon: Icons.calendar_today_outlined,
                  title: 'التاريخ والوقت',
                  value: '$formattedDate\n$formattedTime', // Multi-line
                ),
                const SizedBox(height: 16),

                 // --- Location --- (Placeholder)
                _buildDetailRow(
                  context: context,
                  icon: Icons.location_on_outlined,
                  title: 'الموقع',
                  value: 'شارع الملك فهد، حي العليا، الرياض', // Replace with actual address
                   // Optional: Add a 'View on Map' button if needed
                  // trailing: TextButton(onPressed: (){}, child: Text('عرض الخريطة')),
                ),
                 const SizedBox(height: 16),

                // --- Provider Info ---
                if (booking.providerName != null) ...[
                   _buildDetailRow(
                      context: context,
                      icon: Icons.person_pin_outlined,
                      title: 'مزود الخدمة',
                      // Custom value widget for provider with avatar
                      valueWidget: Row(
                         children: [
                           CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                              backgroundImage: booking.providerAvatarUrl != null ? NetworkImage(booking.providerAvatarUrl!) : null,
                              child: booking.providerAvatarUrl == null ? const Icon(Icons.person, size: 14, color: AppColors.grey) : null,
                           ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                booking.providerName!,
                                 style: textTheme.bodyLarge,
                                 overflow: TextOverflow.ellipsis,
                              ),
                            ),
                         ],
                      ),
                   ),
                  const Divider(height: 24),
                ],

                 // --- Booking ID ---
                 _buildDetailRow(
                  context: context,
                  icon: Icons.tag,
                  title: 'رقم الطلب',
                  value: booking.id,
                ),
                const SizedBox(height: 16),

                // --- Payment/Price Info --- (Placeholder)
                 _buildDetailRow(
                  context: context,
                  icon: Icons.credit_card_outlined,
                  title: 'التكلفة الإجمالية',
                  value: '350 ريال سعودي', // Replace with actual price
                  valueStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                 const SizedBox(height: 16),
                  _buildDetailRow(
                  context: context,
                  icon: Icons.payment_outlined,
                  title: 'حالة الدفع',
                  value: 'مدفوع (Visa **** 1234)', // Replace with actual status
                ),

                const Divider(height: 30),

                // --- Action Buttons (Conditional) ---
                if (booking.status == BookingStatus.upcoming) ...[
                   Row(
                     children: [
                       Expanded(
                         child: OutlinedButton( // Use OutlinedButton for secondary actions
                           onPressed: () {
                             // TODO: Implement Cancellation Logic (show confirmation dialog)
                             print('Cancel Booking Tapped');
                           },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                               padding: const EdgeInsets.symmetric(vertical: 12)
                            ),
                           child: const Text('إلغاء الطلب'),
                         ),
                       ),
                       const SizedBox(width: 12),
                        Expanded(
                         child: PrimaryButton(
                           onPressed: () {
                             // TODO: Implement Reschedule Logic (e.g., open date/time picker)
                              print('Reschedule Booking Tapped');
                           },
                           text: 'إعادة الجدولة',
                         ),
                       ),
                     ],
                   )
                ],

                if (booking.status == BookingStatus.completed) ...[
                   PrimaryButton(
                     onPressed: () {
                       // TODO: Navigate to Rating/Review Screen or Rebook Service
                        print('Rate Service Tapped');
                     },
                     text: 'تقييم الخدمة',
                     minWidth: double.infinity,
                   ),
                ],

                 if (booking.status == BookingStatus.cancelled) ...[
                   PrimaryButton(
                     onPressed: () {
                       // TODO: Navigate to Service screen to book again
                        print('Book Again Tapped');
                     },
                     text: 'طلب الخدمة مرة أخرى',
                     minWidth: double.infinity,
                   ),
                ]


              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? value,
    Widget? valueWidget, // Use this for custom value display
    TextStyle? valueStyle,
    Widget? trailing,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.grey, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.bodyMedium?.copyWith(color: AppColors.grey)),
              const SizedBox(height: 4),
              valueWidget ?? Text(value ?? '-', style: valueStyle ?? textTheme.bodyLarge),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing,
        ]
      ],
    );
  }
}
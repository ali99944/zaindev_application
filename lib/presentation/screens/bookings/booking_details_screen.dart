import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as Intl;

import '../../../core/constants/app_colors.dart';
import '../../../data/models/booking.dart';

// Provider to fetch details for a specific booking (Replace with API)
final bookingDetailsProvider = FutureProvider.family.autoDispose<Booking?, String>((ref, bookingId) async {
  // TODO: Implement API call to fetch booking details by bookingId
  print("Fetching details for booking: $bookingId");
  await Future.delayed(const Duration(seconds: 1));
  // Dummy Data (Find the booking from the dummy list or return null):
  final dummyList = [ // Replicate dummy data from BookingsScreen provider
      Booking(id: 'bk1', bookingCode: 'ZN-12345', serviceName: 'صيانة دورية للمكيف', status: BookingStatus.completed, requestDate: DateTime.now().subtract(const Duration(days: 5)), address: 'الرياض، حي العليا', notes: 'المكيف في غرفة النوم الرئيسية'),
      Booking(id: 'bk2', bookingCode: 'ZN-67890', serviceName: 'تركيب مكيف سبليت', status: BookingStatus.confirmed, requestDate: DateTime.now().subtract(const Duration(days: 2)), scheduledDate: DateTime.now().add(const Duration(days: 1)), scheduledTime: const TimeOfDay(hour: 14, minute: 0), serviceProviderName: 'فني: أحمد خالد'),
      Booking(id: 'bk3', bookingCode: 'ZN-11223', serviceName: 'إصلاح أعطال كهربائية', status: BookingStatus.inProgress, requestDate: DateTime.now().subtract(const Duration(days: 1))),
      Booking(id: 'bk4', bookingCode: 'ZN-44556', serviceName: 'طلب استشارة فنية', status: BookingStatus.pending, requestDate: DateTime.now()),
      Booking(id: 'bk5', bookingCode: 'ZN-77889', serviceName: 'تنظيف مكيفات', status: BookingStatus.cancelled, requestDate: DateTime.now().subtract(const Duration(days: 10))),
  ];
  try {
     return dummyList.firstWhere((b) => b.id == bookingId);
  } catch (e) {
     return null; // Not found
  }
});


class BookingDetailsScreen extends ConsumerWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsyncValue = ref.watch(bookingDetailsProvider(bookingId));
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = Intl.DateFormat('EEEE، dd MMM yyyy', 'ar'); // Full date format
    final timeFormat = Intl.DateFormat('hh:mm a', 'ar'); // Time format

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الطلب')),
        body: detailsAsyncValue.when(
          data: (booking) {
            if (booking == null) {
               return const Center(child: Text('لم يتم العثور على تفاصيل هذا الطلب.'));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header: Service Name & Status ---
                  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        Expanded(child: Text(booking.serviceName, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary))),
                        Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                           decoration: BoxDecoration(color: booking.statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                           child: Text(booking.statusDisplay, style: textTheme.bodyMedium?.copyWith(color: booking.statusColor, fontWeight: FontWeight.bold)),
                        ),
                     ],
                  ),
                  const SizedBox(height: 8),
                  Text('رمز الطلب: ${booking.bookingCode}', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                  const Divider(height: 24),

                  // --- Booking Details Section ---
                  _buildDetailRow(context, Icons.calendar_today_outlined, 'تاريخ الطلب', dateFormat.format(booking.requestDate)),
                  if (booking.scheduledDate != null)
                     _buildDetailRow(context, Icons.event_available, 'موعد التنفيذ', dateFormat.format(booking.scheduledDate!) + (booking.scheduledTime != null ? ' - ${booking.scheduledTime!.format(context)}' : '')), // Format time
                  if (booking.address != null)
                      _buildDetailRow(context, Icons.location_on_outlined, 'العنوان', booking.address!),
                   if (booking.serviceProviderName != null)
                      _buildDetailRow(context, Icons.person_pin_outlined, 'مزود الخدمة', booking.serviceProviderName!),
                  if (booking.notes != null && booking.notes!.isNotEmpty)
                     _buildDetailRow(context, Icons.notes_outlined, 'الملاحظات', booking.notes!, isMultiline: true),

                  const Divider(height: 24),

                  // --- Action Buttons (Conditional) ---
                   if (booking.status == BookingStatus.pending || booking.status == BookingStatus.confirmed)
                      Center(
                         child: OutlinedButton.icon(
                           icon: const Icon(Icons.cancel_outlined),
                           label: const Text('إلغاء الطلب'),
                           style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
                           onPressed: () {
                             // TODO: Implement cancel booking logic + confirmation dialog
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cancel Booking - Placeholder')));
                           },
                         ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                         child: TextButton.icon(
                             icon: const Icon(Icons.support_agent_outlined),
                             label: const Text('المساعدة بخصوص هذا الطلب'),
                             onPressed: () {
                               // TODO: Navigate to support, maybe passing booking code
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact Support - Placeholder')));
                             },
                         ),
                      ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, stack) => Center(child: Text('خطأ في تحميل التفاصيل: $error')),
        ),
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value, {bool isMultiline = false}) {
     final textTheme = Theme.of(context).textTheme;
     return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
           crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
           children: [
              Icon(icon, size: 20, color: AppColors.primary.withOpacity(0.8)),
              const SizedBox(width: 12),
              Text('$label: ', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(width: 4),
              Expanded(child: Text(value, style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary))),
           ],
        ),
     );
  }
}
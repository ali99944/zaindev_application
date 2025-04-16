import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/booking.dart';
import '../home/home_screen.dart'; // Import Booking model

// Provider to fetch user's bookings (Replace with actual API call)
final userBookingsProvider = FutureProvider.autoDispose<List<Booking>>((ref) async {
  // TODO: Implement API call to fetch user bookings
  await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  // Dummy Data (Replace):
  return [
    Booking(id: 'bk1', bookingCode: 'ZN-12345', serviceName: 'صيانة دورية للمكيف', status: BookingStatus.completed, requestDate: DateTime.now().subtract(const Duration(days: 5))),
    Booking(id: 'bk2', bookingCode: 'ZN-67890', serviceName: 'تركيب مكيف سبليت', status: BookingStatus.confirmed, requestDate: DateTime.now().subtract(const Duration(days: 2)), scheduledDate: DateTime.now().add(const Duration(days: 1))),
    Booking(id: 'bk3', bookingCode: 'ZN-11223', serviceName: 'إصلاح أعطال كهربائية', status: BookingStatus.inProgress, requestDate: DateTime.now().subtract(const Duration(days: 1))),
    Booking(id: 'bk4', bookingCode: 'ZN-44556', serviceName: 'طلب استشارة فنية', status: BookingStatus.pending, requestDate: DateTime.now()),
    Booking(id: 'bk5', bookingCode: 'ZN-77889', serviceName: 'تنظيف مكيفات', status: BookingStatus.cancelled, requestDate: DateTime.now().subtract(const Duration(days: 10))),
  ];
});


class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  Future<void> _refreshBookings(WidgetRef ref) async {
     // Invalidate the provider to trigger a refetch
     ref.invalidate(userBookingsProvider);
     // No need to await here, the provider will handle the loading state
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsyncValue = ref.watch(userBookingsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold( // Add Scaffold if this is a standalone screen
      // appBar: AppBar(title: const Text('حجوزاتي')), // Add AppBar if standalone
      body: RefreshIndicator(
         onRefresh: () => _refreshBookings(ref),
         color: AppColors.primary,
         child: bookingsAsyncValue.when(
           data: (bookings) {
              if (bookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.list_alt_outlined, size: 60, color: AppColors.disabled),
                      const SizedBox(height: 16),
                      Text('لا توجد حجوزات أو طلبات حالية.', style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                           // Navigate to services or home
                            ref.read(bottomNavIndexProvider.notifier).state = 1; // Go to Services tab
                        },
                        child: const Text('اطلب خدمة الآن'),
                      )
                    ],
                  ),
                );
              }
              return ListView.separated(
                 padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                 itemCount: bookings.length,
                 itemBuilder: (context, index) {
                    return _BookingListItem(booking: bookings[index]);
                 },
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
              );
           },
           loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
           error: (error, stack) => Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Icon(Icons.error_outline, color: AppColors.accent, size: 40),
                   const SizedBox(height: 10),
                   Text('حدث خطأ أثناء تحميل الحجوزات: $error', textAlign: TextAlign.center),
                   const SizedBox(height: 10),
                   ElevatedButton(onPressed: () => _refreshBookings(ref), child: const Text('إعادة المحاولة'))
                 ],
               ),
           ),
         ),
      ),
    );
  }
}

// --- Reusable Booking List Item ---
class _BookingListItem extends StatelessWidget {
   final Booking booking;
   const _BookingListItem({required this.booking});

  @override
  Widget build(BuildContext context) {
     final textTheme = Theme.of(context).textTheme;
     final dateFormat = DateFormat('dd MMM yyyy', 'ar'); // Arabic date format

    return InkWell(
      onTap: () {
         Navigator.pushNamed(context, AppRoutes.bookingDetails, arguments: booking.id);
      },
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
         decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: AppColors.divider.withOpacity(0.7)),
         ),
         child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(booking.serviceName, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                       color: booking.statusColor.withOpacity(0.1),
                       borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                       booking.statusDisplay,
                       style: textTheme.bodySmall?.copyWith(color: booking.statusColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                 children: [
                    Icon(Icons.receipt_long_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text('الرمز: ${booking.bookingCode}', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    const Spacer(),
                    Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('طلب في: ${dateFormat.format(booking.requestDate)}', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                 ],
              ),
              // Optionally show scheduled date if available
              if (booking.scheduledDate != null) ... [
                 const SizedBox(height: 4),
                  Row(
                     children: [
                         Icon(Icons.event_available, size: 16, color: Colors.green.shade700),
                         const SizedBox(width: 6),
                         Text('موعد التنفيذ: ${dateFormat.format(booking.scheduledDate!)}', style: textTheme.bodyMedium?.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.w500)),
                     ],
                  ),
              ]
            ],
         ),
      ),
    );
  }
}
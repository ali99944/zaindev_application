import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/presentation/screens/bookings/booking_details_screen.dart';

import '../../../core/constants/app_colors.dart';
import 'booking_list_item.dart'; // Import list item widget

// Enum for booking status (or use strings from API)
enum BookingStatus { upcoming, completed, cancelled }

// Dummy Booking Data Model (replace with actual model from domain/data)
class BookingInfo {
  final String id;
  final String serviceName;
  final DateTime dateTime;
  final BookingStatus status;
  final String? providerName; // Optional
  final String? providerAvatarUrl; // Optional

  BookingInfo({
    required this.id,
    required this.serviceName,
    required this.dateTime,
    required this.status,
    this.providerName,
    this.providerAvatarUrl,
  });
}

// Dummy Data Provider (replace with actual Riverpod provider fetching data)
final bookingsProvider = Provider<List<BookingInfo>>((ref) {
  // Simulate fetching data
  return [
    BookingInfo(id: 'b1', serviceName: 'تركيب مكيف سبليت', dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)), status: BookingStatus.upcoming, providerName: 'أحمد خالد', providerAvatarUrl: 'https://via.placeholder.com/100'),
    BookingInfo(id: 'b2', serviceName: 'صيانة دورية لوحدة مركزية', dateTime: DateTime.now().subtract(const Duration(days: 5)), status: BookingStatus.completed),
    BookingInfo(id: 'b3', serviceName: 'استشارة فنية لمشروع جديد', dateTime: DateTime.now().add(const Duration(days: 7)), status: BookingStatus.upcoming, providerName: 'شركة التكييف الحديث'),
    BookingInfo(id: 'b4', serviceName: 'تنظيف فلاتر مكيف شباك', dateTime: DateTime.now().subtract(const Duration(days: 10)), status: BookingStatus.cancelled),
     BookingInfo(id: 'b5', serviceName: 'تركيب مكيف صحراوي', dateTime: DateTime.now().add(const Duration(days: 1, hours: 1)), status: BookingStatus.upcoming, providerName: 'فني مستقل', providerAvatarUrl: 'https://via.placeholder.com/100'),
    BookingInfo(id: 'b6', serviceName: 'فحص تسريب فريون', dateTime: DateTime.now().subtract(const Duration(days: 1)), status: BookingStatus.completed, providerName: 'مركز الصيانة السريع'),
  ];
});

// Provider for the selected filter
final bookingFilterProvider = StateProvider<BookingStatus?>((ref) => BookingStatus.upcoming); // Default to upcoming

// Filtered list provider
final filteredBookingsProvider = Provider<List<BookingInfo>>((ref) {
  final allBookings = ref.watch(bookingsProvider);
  final filter = ref.watch(bookingFilterProvider);
  if (filter == null) {
    return allBookings; // No filter
  }
  return allBookings.where((booking) => booking.status == filter).toList();
});


class BookingsScreen extends ConsumerWidget {
  static const String route = "/bookings";
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredBookings = ref.watch(filteredBookingsProvider);
    final currentFilter = ref.watch(bookingFilterProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController( // Use TabController for filtering
        length: 3, // Number of filters (Upcoming, Completed, Cancelled)
        initialIndex: 0, // Start with 'Upcoming' selected
         // Listen to tab changes to update the filter provider
         // Using listener on DefaultTabController is a bit tricky,
         // Alternatively, use custom TabBar with onTap or a dedicated controller
        child: Scaffold(
          appBar: AppBar(
            title: const Text('طلباتي'),
            bottom: TabBar(
               indicatorColor: AppColors.primary,
               labelColor: AppColors.primary,
               unselectedLabelColor: AppColors.grey,
               indicatorWeight: 2.5,
               labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
               unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
               onTap: (index) {
                 BookingStatus? newFilter;
                 if (index == 0) newFilter = BookingStatus.upcoming;
                 else if (index == 1) newFilter = BookingStatus.completed;
                 else if (index == 2) newFilter = BookingStatus.cancelled;
                 ref.read(bookingFilterProvider.notifier).state = newFilter;
               },
              tabs: const [
                Tab(text: 'القادمة'),
                Tab(text: 'المكتملة'),
                Tab(text: 'الملغاة'),
              ],
            ),
          ),
          body: filteredBookings.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد طلبات ${ _getFilterName(currentFilter)} حالياً.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return BookingListItem( // Use the dedicated list item widget
                       booking: booking,
                       onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BookingDetailsScreen(bookingId: booking.id);
                              }
                            )
                          );
                       },
                    );
                  },
                ),
        ),
      ),
    );
  }

   String _getFilterName(BookingStatus? status) {
     switch(status) {
       case BookingStatus.upcoming: return 'قادمة';
       case BookingStatus.completed: return 'مكتملة';
       case BookingStatus.cancelled: return 'ملغاة';
       default: return '';
     }
   }
}
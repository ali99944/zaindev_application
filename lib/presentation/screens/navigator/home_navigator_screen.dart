import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:zaindev_application/core/routing/router_utils.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../widgets/app_drawer.dart';
import '../bookings/bookings_screen.dart';
import '../home/home_screen.dart';
import '../more/more_screen.dart';
import '../services/services_categories_screen.dart';// Adjusted path if needed


// Provider to hold the current selected index of the bottom navigation bar
final bottomNavIndexProvider = StateProvider<int>((ref) => 0); // Default to Home (index 0)

class HomeNavigatorScreen extends ConsumerWidget {
  const HomeNavigatorScreen({super.key});

  // List of the pages to be displayed by the bottom navigation bar
  static const List<Widget> _navPages = <Widget>[
    HomePage(),
    ServicesCategoriesPage(),
    BookingsScreen(), // Use placeholder for now
    MorePage(),
  ];

  // Optional: Titles corresponding to the pages
  static const List<String> _navTitles = <String>[
    'الرئيسية', // Home
    'الخدمات',  // Services
    'الحجوزات', // Bookings
    'المزيد',    // More
  ];


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Directionality(
      textDirection: TextDirection.rtl, // Ensure RTL layout
      child: Scaffold(
        appBar: AppBar(
          title: Text(_navTitles[currentIndex]),
          backgroundColor: AppColors.primary,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  navigateNamed(context, AppRoutes.profile);
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: CircleAvatar(
                    backgroundColor: AppColors.accent,
                    child: Icon(Icons.person, color: AppColors.textOnPrimary,),
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: IndexedStack(
          index: currentIndex,
          children: _navPages,
        ),

        // --- Replace FloatingActionButton with SpeedDial ---
        floatingActionButton: SpeedDial(
          // Icons
          icon: Icons.support_agent_outlined, // Main button icon when closed
          activeIcon: Icons.close, // Main button icon when open

          // Button Appearance
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textOnAccent,
          buttonSize: const Size(56.0, 56.0), // Default FAB size
          childrenButtonSize: const Size(50.0, 50.0), // Slightly smaller children
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Your desired shape
          elevation: 0, // Consistent with theme

          // Menu Items (Children)
          children: [
            SpeedDialChild(
              child: const Icon(Icons.headset_mic_outlined),
              label: 'احصل على استشارة', // Get Consultation
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              labelBackgroundColor: AppColors.background.withOpacity(0.9),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () => Navigator.pushNamed(context, AppRoutes.consultation),
            ),
            SpeedDialChild(
              child: const Icon(Icons.add_circle_outline),
              label: 'اطلب خدمة الآن', // Request Service Now
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              labelBackgroundColor: AppColors.background.withOpacity(0.9),
               elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () => Navigator.pushNamed(context, AppRoutes.serviceList),
            ),
            SpeedDialChild(
              child: const Icon(Icons.build_circle_outlined),
              label: 'الدعم الفني', // Technical Support
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              labelBackgroundColor: AppColors.background.withOpacity(0.9),
               elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () => Navigator.pushNamed(context, AppRoutes.support), // Point to main support
            ),
             SpeedDialChild(
              child: const Icon(Icons.call_outlined),
              label: 'تواصل معنا', // Contact Us
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              labelBackgroundColor: AppColors.background.withOpacity(0.9),
               elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () => Navigator.pushNamed(context, AppRoutes.contactUs), // Point to contact/support
            ),
          ],

          // Animation and Overlay
          animationCurve: Curves.elasticInOut,
          animationDuration: const Duration(milliseconds: 300),
          overlayColor: Colors.black,
          overlayOpacity: 0.4,

          // Other options if needed:
          // spacing: 10, // Space between main button and children
          // childrenAreCircular: true, // Make children circular FABS
          // closeManually: false, // Close menu automatically on tap
        ),
        // --- End of SpeedDial ---

        // FAB Location - Use endFloat or startFloat for non-docked
        // In RTL, endFloat places it on the left. startFloat on the right.
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

        // Bottom Navigation Bar remains the same
        bottomNavigationBar: BottomNavigationBar(
           currentIndex: currentIndex,
          onTap: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary.withOpacity(0.7),
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const <BottomNavigationBarItem>[
             BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
               activeIcon: Icon(Icons.grid_view_rounded),
              label: 'الخدمات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
               activeIcon: Icon(Icons.calendar_today),
              label: 'الحجوزات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_outlined),
              activeIcon: Icon(Icons.more_horiz),
              label: 'المزيد',
            ),
          ],
        ),
      ),
    );
  }
}
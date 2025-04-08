import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/presentation/screens/bookings/bookings_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../profile/profile_screen.dart';
import '../services/services_screen.dart';
import 'home_screen.dart'; // For placeholder

// Define the screens for each tab
final List<Widget> _screens = [
  const HomeScreen(), // Index 0: Home
  const AllServiceCategoriesScreen(), // Index 1: Services Categories
  BookingsScreen(), // Index 2: Projects/Bookings placeholder
  const ProfileScreen(), // Index 3: Profile
];

class HomeNavigatorScreen extends ConsumerStatefulWidget {
  // Remove static route if using route generator
  static const String route = "/home-navigator";
  const HomeNavigatorScreen({super.key});

  @override
  ConsumerState<HomeNavigatorScreen> createState() => _HomeNavigatorScreenState();
}

class _HomeNavigatorScreenState extends ConsumerState<HomeNavigatorScreen> {
  int _currentIndex = 0; // Start with the Home tab

  void _onNavItemTapped(int index) {
    // Prevent navigating to the center 'gap' if logic were different
    // In this setup, indices 0, 1, 2, 3 map directly
    setState(() {
      _currentIndex = index;
    });
  }

  // --- FAB Menu Action ---
  void _showFabMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              _buildFabMenuItem(
                context,
                icon: Icons.add_business_outlined,
                text: 'بدء مشروع جديد',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Start Project Screen
                  print('Navigate to Start Project');
                  // Navigator.pushNamed(context, AppRoutes.startProject);
                },
              ),
              const Divider(height: 15, thickness: 0.5),
              _buildFabMenuItem(
                context,
                icon: Icons.search,
                text: 'البحث عن خدمة',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Focus search bar or navigate
                  print('Navigate/Focus Search');
                },
              ),
               const Divider(height: 15, thickness: 0.5),
              _buildFabMenuItem(
                context,
                icon: Icons.support_agent_outlined,
                text: 'التواصل مع الدعم',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Support
                  print('Navigate to Support');
                  // Navigator.pushNamed(context, AppRoutes.contactSupport);
                },
              ),
               const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Helper to build items in the FAB menu sheet
  Widget _buildFabMenuItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
     final textTheme = Theme.of(context).textTheme;
     return InkWell(
       onTap: onTap,
       child: Padding(
         padding: const EdgeInsets.symmetric(vertical: 12.0),
         child: Row(
           children: [
             Icon(icon, color: AppColors.primary, size: 26),
             const SizedBox(width: 16),
             Expanded(child: Text(text, style: textTheme.bodyLarge)),
             const Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
           ],
         ),
       ),
     );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFabMenu(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.black,
        elevation: 2.0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppColors.white,
        elevation: 8.0,
        child: SizedBox( // Keep SizedBox for defined height
          height: 60, // Use standard height 60-65
          child: Row(
             // Use spaceAround to distribute items evenly including space for the notch
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Use Expanded for nav items directly under the main Row
              _buildNavItem(index: 0, icon: Icons.home_outlined, activeIcon: Icons.home, label: 'الرئيسية'),
              _buildNavItem(index: 1, icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, label: 'الخدمات'),
              // This SizedBox acts as a spacer for the center FAB notch
              // Adjust width based on FAB size and notchMargin if needed
              _buildNavItem(index: 2, icon: Icons.list_alt_outlined, activeIcon: Icons.list_alt_rounded, label: 'الطلبات'), // Changed label
              _buildNavItem(index: 3, icon: Icons.person_outline, activeIcon: Icons.person, label: 'حسابي'),
            ],
          ),
        ),
      ),
    );
  }

   // Helper widget to build each navigation item
  Widget _buildNavItem({required int index, required IconData icon, required IconData activeIcon, required String label}) {
    bool isSelected = _currentIndex == index;
    return Expanded( // Use Expanded here
      child: MaterialButton(
        minWidth: 20,
        padding: EdgeInsets.zero,
        onPressed: () => _onNavItemTapped(index),
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.grey,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
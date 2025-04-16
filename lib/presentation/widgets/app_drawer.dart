import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Use ConsumerWidget if accessing providers

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../screens/home/home_screen.dart'; // For bottomNavIndexProvider

// Assuming bottomNavIndexProvider is defined in home_navigator_screen.dart
// If not, define it here or in a shared provider file.

class AppDrawer extends ConsumerWidget { // Changed to ConsumerWidget
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    // TODO: Replace with actual check from auth provider
    bool isLoggedIn = false; // Placeholder

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppAssets.logo,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.business_sharp, size: 60, color: AppColors.textOnPrimary),
                ),
                const SizedBox(height: 10),
                Text(
                  'زين التنموية',
                  style: textTheme.titleLarge?.copyWith(color: AppColors.textOnPrimary),
                ),
              ],
            ),
          ),

          // --- Main Navigation Group ---
          // These will close the drawer and rely on the user tapping the bottom bar
          // Or, you could update the bottomNavIndexProvider here.
          _buildDrawerItem(
            context: context,
            ref: ref, // Pass ref
            icon: Icons.home_outlined,
            text: 'الرئيسية', // Home
            targetIndex: 0, // Index for Home tab
          ),
          _buildDrawerItem(
            context: context,
             ref: ref,
            icon: Icons.grid_view_outlined,
            text: 'الخدمات', // Services
            targetIndex: 1, // Index for Services tab
          ),
          _buildDrawerItem(
            context: context,
             ref: ref,
            icon: Icons.calendar_today_outlined,
            text: 'الحجوزات', // Bookings
            targetIndex: 2, // Index for Bookings tab
          ),

          const Divider(indent: 16, endIndent: 16),

          // --- Information Group ---
           _buildDrawerItem(
            context: context,
             ref: ref,
            icon: Icons.info_outline,
            text: 'عن زين التنموية', // About Zain Dev
            route: AppRoutes.aboutUs,
          ),
          _buildDrawerItem(
            context: context,
             ref: ref,
            icon: Icons.work_outline,
            text: 'مشاريعنا', // Our Projects
            route: AppRoutes.projects, // Assuming you have a ProjectsScreen placeholder
          ),

           const Divider(indent: 16, endIndent: 16),

          // --- Support & Account Group ---
          _buildDrawerItem(
            context: context,
             ref: ref,
            icon: Icons.support_agent_outlined,
            text: 'الدعم والمساعدة', // Support & Help
            route: AppRoutes.support,
          ),
           _buildDrawerItem(
            context: context,
             ref: ref,
            icon: Icons.phone_in_talk_outlined, // Specific icon for contact
            text: 'تواصل معنا', // Contact Us
            route: AppRoutes.contactUs,
          ),

          if (isLoggedIn) ...[
             _buildDrawerItem(
              context: context,
              ref: ref,
              icon: Icons.person_outline,
              text: 'الملف الشخصي', // Profile
              route: AppRoutes.profile, // TODO: Add Profile screen & route
            ),
          ] else ...[
              _buildDrawerItem(
                context: context,
                ref: ref,
                icon: Icons.login,
                text: 'تسجيل الدخول', // Login
                route: AppRoutes.login, // TODO: Add Login screen & route
            ),
          ],
           _buildDrawerItem(
            context: context,
             ref: ref,
            icon: Icons.settings_outlined,
            text: 'الإعدادات', // Settings
            route: AppRoutes.settings, // Assuming you have a SettingsScreen placeholder
          ),

            if (isLoggedIn) ...[
               const Divider(indent: 16, endIndent: 16),
               _buildDrawerItem(
                  context: context,
                  ref: ref,
                  icon: Icons.logout,
                  text: 'تسجيل الخروج', // Logout
                  color: AppColors.accent,
                  onTap: () {
                    // TODO: Implement logout logic here
                     Navigator.pop(context); // Close drawer first
                     // Show confirmation dialog, call auth provider, navigate
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout action placeholder')),
                      );
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (route) => false);
                  },
                ),
            ],
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required WidgetRef ref, // Need ref to change bottom nav index
    required IconData icon,
    required String text,
    String? route,
    int? targetIndex, // Index for bottom navigation bar
    VoidCallback? onTap,
    Color? color,
  }) {
     final effectiveColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary.withOpacity(0.8), size: 24),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: effectiveColor),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      visualDensity: VisualDensity.compact,
      onTap: () {
        Navigator.pop(context); // Close the drawer first

        // Short delay allows drawer animation to finish before navigating or switching tabs
        Future.delayed(const Duration(milliseconds: 100), () {
          if (onTap != null) {
            onTap(); // Custom action
          } else if (targetIndex != null) {
             // Switch Tab using the provider
             ref.read(bottomNavIndexProvider.notifier).state = targetIndex;
          } else if (route != null) {
            // Navigate to a separate screen
            Navigator.pushNamed(context, route);
          }
        });
      },
    );
  }
}
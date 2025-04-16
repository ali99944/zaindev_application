import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual check from auth provider
    bool isLoggedIn = false; // Placeholder for authentication status

    return ListView(
      children: [
        const SizedBox(height: 8), // Top padding

        _buildGroupTitle(context, 'عن التطبيق'), // About the App
        _buildListTile(
          context: context,
          icon: Icons.info_outline,
          title: 'عن زين التنموية', // About Zain Dev
          route: AppRoutes.aboutUs,
        ),
        _buildListTile(
          context: context,
          icon: Icons.info_outline,
          title: 'تواصل معنا', // About Zain Dev
          route: AppRoutes.contactUs,
        ),
         _buildListTile(
          context: context,
          icon: Icons.work_outline,
          title: 'مشاريعنا', // Our Projects
          route: AppRoutes.projects,
        ),
         _buildListTile(
          context: context,
          icon: Icons.support_agent_outlined,
          title: 'الدعم والمساعدة', // Support & Help
          route: AppRoutes.support,
        ),

        const Divider(indent: 16, endIndent: 16, height: 24),

         _buildGroupTitle(context, 'الحساب والإعدادات'), // Account & Settings
         if (isLoggedIn) ...[
             _buildListTile(
              context: context,
              icon: Icons.person_outline,
              title: 'الملف الشخصي', // Profile
              route: AppRoutes.profile, // TODO: Create Profile route & screen
            ),
             _buildListTile(
              context: context,
              icon: Icons.history_outlined,
              title: 'تتبع الطلبات', // Track Orders (if applicable to logged-in user)
              route: AppRoutes.trackOrder, // TODO: Create Track Order route & screen
            ),
         ] else ...[
             _buildListTile(
              context: context,
              icon: Icons.login,
              title: 'تسجيل الدخول / إنشاء حساب', // Login / Create Account
              route: AppRoutes.welcome, // Go back to Welcome to choose Login/Register
              // Or directly to AppRoutes.login
            ),
              _buildListTile(
              context: context,
              icon: Icons.history_outlined,
              title: 'تتبع طلب (زائر)', // Track Order (Guest) - As per report
              route: AppRoutes.trackOrder, // TODO: Create Track Order route & screen (for guest)
            ),
         ],

        _buildListTile(
          context: context,
          icon: Icons.settings_outlined,
          title: 'الإعدادات', // Settings
          route: AppRoutes.settings,
        ),

         const Divider(indent: 16, endIndent: 16, height: 24),

         _buildGroupTitle(context, 'الاستشارات'), // Legal
        _buildListTile(
          context: context,
          icon: Icons.chat_outlined,
          title: 'احصل علي استشارة', // Privacy Policy
          route: AppRoutes.requestConsultation, // TODO: Create route & screen
        ),
        _buildListTile(
          context: context,
          icon: Icons.list_outlined,
          title: 'باقات الاستشارات', // Terms & Conditions
          route: AppRoutes.consultationPackages, // TODO: Create route & screen
        ),

         _buildGroupTitle(context, 'قانوني'), // Legal
        _buildListTile(
          context: context,
          icon: Icons.policy_outlined,
          title: 'سياسة الخصوصية', // Privacy Policy
          route: AppRoutes.privacyPolicy, // TODO: Create route & screen
        ),
        _buildListTile(
          context: context,
          icon: Icons.description_outlined,
          title: 'الشروط والأحكام', // Terms & Conditions
          route: AppRoutes.termsConditions, // TODO: Create route & screen
        ),

        if (isLoggedIn) ...[
           const Divider(indent: 16, endIndent: 16, height: 24),
           _buildListTile(
            context: context,
            icon: Icons.logout,
            title: 'تسجيل الخروج', // Logout
            color: AppColors.accent, // Use accent color for logout
            onTap: () {
              // TODO: Implement logout logic
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('تسجيل الخروج'),
                  content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        // Call logout function from auth provider
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logout action placeholder')),
                        );
                         // Navigate to welcome or login screen after logout
                         Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (route) => false);
                      },
                      child: const Text('تأكيد', style: TextStyle(color: AppColors.accent)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 20),
         // Optional: App Version display
          // Center(child: Text('Version 1.0.0', style: Theme.of(context).textTheme.labelSmall)),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper for section titles in the list
  Widget _buildGroupTitle(BuildContext context, String title) {
    return Padding(
       padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // Reusable ListTile builder for this page
  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
    Color? color, // Optional color override for icon/text
  }) {
    final effectiveColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary.withOpacity(0.9), size: 24),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: effectiveColor),
      ),
      trailing: (onTap != null || route != null)
          ? Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary.withOpacity(0.7))
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      visualDensity: VisualDensity.compact,
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
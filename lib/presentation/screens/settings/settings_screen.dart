import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

// Placeholder Provider for Authentication State
final authStateProvider = Provider<bool>((ref) {
  // TODO: Replace with actual authentication check (e.g., watching an Auth Repository/Service)
  return false; // Assume logged out by default for now
});

// Placeholder Providers for settings values (replace with SharedPreferences/backend)
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
final selectedLanguageProvider = StateProvider<String>((ref) => 'ar'); // 'ar' or 'en'

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

   // Helper for section titles (similar to MorePage)
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

  // Reusable ListTile builder (similar to MorePage)
  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    String? route,
    VoidCallback? onTap,
    Widget? trailing,
    Color? color,
  }) {
    final effectiveColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary.withOpacity(0.9), size: 24),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: effectiveColor),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))
          : null,
      trailing: trailing ?? ((onTap != null || route != null)
          ? Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary.withOpacity(0.7))
          : null),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: subtitle != null ? 4 : 0),
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


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authStateProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final selectedLanguage = ref.watch(selectedLanguageProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: ListView(
          children: [
            const SizedBox(height: 8),

             // --- Account Section (Visible if logged in) ---
            if (isLoggedIn) ...[
               _buildGroupTitle(context, 'الحساب'),
                _buildListTile(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'تعديل الملف الشخصي',
                  route: AppRoutes.profile, // TODO: Create Profile screen
                ),
                _buildListTile(
                  context: context,
                  icon: Icons.lock_outline,
                  title: 'تغيير كلمة المرور',
                  route: AppRoutes.changePassword, // TODO: Create Change Password screen
                ),
                const Divider(indent: 16, endIndent: 16, height: 24),
            ],

             // --- Application Settings ---
            _buildGroupTitle(context, 'إعدادات التطبيق'),
            _buildListTile(
              context: context,
              icon: Icons.language_outlined,
              title: 'اللغة',
              subtitle: selectedLanguage == 'ar' ? 'العربية' : 'English',
              onTap: () {
                 // TODO: Show language selection dialog/screen
                  ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Language Selection - Coming Soon!'))
                  );
                 // Example: ref.read(selectedLanguageProvider.notifier).state = 'en';
                 // Then update MaterialApp locale in main.dart based on this provider/saved pref
              },
               trailing: Row( // Custom trailing for language indicator
                 mainAxisSize: MainAxisSize.min,
                 children: [
                    Text(selectedLanguage == 'ar' ? 'العربية' : 'English', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary.withOpacity(0.7)),
                 ],
               ),
            ),
             _buildListTile(
              context: context,
              icon: Icons.notifications_outlined,
              title: 'الإشعارات',
              onTap: () {
                // Toggle or navigate to detailed notifications screen
                ref.read(notificationsEnabledProvider.notifier).update((state) => !state);
                 // TODO: Save preference and handle push notification registration/unregistration
              },
              trailing: Switch(
                 value: notificationsEnabled,
                 onChanged: (value) {
                     ref.read(notificationsEnabledProvider.notifier).state = value;
                     // TODO: Save preference and handle push notification registration/unregistration
                 },
                 activeColor: AppColors.primary,
                 // inactiveThumbColor: AppColors.disabled, // Optional styling
              ),
            ),

             const Divider(indent: 16, endIndent: 16, height: 24),

             // --- Information & Legal ---
             _buildGroupTitle(context, 'المعلومات والمساعدة'),
              _buildListTile(
                context: context,
                icon: Icons.info_outline,
                title: 'عن زين التنموية',
                route: AppRoutes.aboutUs,
              ),
               _buildListTile(
                context: context,
                icon: Icons.support_agent_outlined,
                title: 'الدعم والمساعدة',
                route: AppRoutes.support,
              ),
              _buildListTile(
                context: context,
                icon: Icons.phone_in_talk_outlined,
                title: 'تواصل معنا',
                route: AppRoutes.contactUs,
              ),
               _buildListTile(
                context: context,
                icon: Icons.policy_outlined,
                title: 'سياسة الخصوصية',
                route: AppRoutes.privacyPolicy,
              ),
              _buildListTile(
                context: context,
                icon: Icons.description_outlined,
                title: 'الشروط والأحكام',
                route: AppRoutes.termsConditions,
              ),

               const Divider(indent: 16, endIndent: 16, height: 24),

               // --- Authentication Action ---
                _buildListTile(
                  context: context,
                  icon: isLoggedIn ? Icons.logout : Icons.login,
                  title: isLoggedIn ? 'تسجيل الخروج' : 'تسجيل الدخول',
                  color: isLoggedIn ? AppColors.accent : AppColors.primary,
                  trailing: null, // No arrow needed for action
                  onTap: () {
                     if (isLoggedIn) {
                        // TODO: Implement Logout Logic (Show confirmation, call auth provider, navigate)
                         showDialog(
                           context: context,
                           builder: (ctx) => AlertDialog( /* ... Logout Confirmation ... */ ),
                         );
                         // Placeholder:
                        //  ref.read(authStateProvider.notifier).state = false; // Update placeholder state
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج')));
                         // Maybe navigate away from settings after logout? Or just rebuild screen.

                     } else {
                        // Navigate to Login screen
                         Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                     }
                  },
                ),
              const SizedBox(height: 20),
               // Optional: App Version display
               // Center(child: Text('Version 1.0.1', style: Theme.of(context).textTheme.labelSmall)),
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
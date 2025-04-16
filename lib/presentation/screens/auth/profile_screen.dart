import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/presentation/screens/navigator/home_navigator_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import 'auth_providers.dart'; // Import auth providers

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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

     void _showConfirmationDialog({
      required BuildContext context,
      required String title,
      required String content,
      required String confirmText,
      required VoidCallback onConfirm,
      Color confirmColor = AppColors.accent,
    }) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onConfirm();
              },
              child: Text(confirmText, style: TextStyle(color: confirmColor)),
            ),
          ],
        ),
      );
    }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final textTheme = Theme.of(context).textTheme;
     // Watch the main auth state
     final authState = ref.watch(authNotifierProvider);
     final authNotifier = ref.read(authNotifierProvider.notifier);

     // If not authenticated or user data is null, show loading or redirect
     // (AuthWrapper should ideally handle redirect before reaching here)
     if (!authState.isAuthenticated || authState.user == null) {
        print("ProfileScreen: User not authenticated or data missing, showing loader.");
        // Attempt to refresh profile if token exists but user is null (maybe initial load failed)
        if(authState.token != null && authState.user == null && !authState.isLoading) {
            Future.microtask(() => authNotifier.refreshUserProfile());
        }
        return Scaffold(appBar: AppBar(title: const Text('الملف الشخصي')), body: const Center(child: CircularProgressIndicator()));
     }

     final user = authState.user!; // Safe to use ! because of the check above

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
           title: const Text('الملف الشخصي'),
           actions: [
              IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                      // TODO: Navigate to Edit Profile Screen
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit Profile - Coming Soon')));
                  },
              ),
           ],
        ),
        body: RefreshIndicator( // Add pull-to-refresh
           onRefresh: () => authNotifier.refreshUserProfile(),
           color: AppColors.primary,
           child: ListView(
            children: [
               // --- User Info Header ---
              Container(
                padding: const EdgeInsets.all(20.0),
                color: AppColors.primary.withOpacity(0.05),
                child: Row(
                  // ... (Display user info from user object) ...
                  children: [
                     CircleAvatar( /* ... (Use user.imageUrl placeholder) ... */ ),
                     const SizedBox(width: 16),
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(user.name, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                           const SizedBox(height: 4),
                           Text(user.email, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                            if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
                               const SizedBox(height: 2),
                               Text(user.phoneNumber!, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary), textDirection: TextDirection.ltr, textAlign: TextAlign.right),
                            ]
                         ],
                       ),
                     ),
                  ],
                ),
              ),

              // --- Quick Navigation/User Stuffs ---
              _buildGroupTitle(context, 'أنشطتي'),
              _buildListTile(context: context, icon: Icons.calendar_today_outlined, title: 'الحجوزات والطلبات', onTap: () {
                  // Navigate to Bookings Tab
                  ref.read(bottomNavIndexProvider.notifier).state = 2; // Assuming index 2 is Bookings
                  // If Profile is pushed on top, pop first, then switch tab if needed
                  if (Navigator.canPop(context)) Navigator.pop(context);
              }),
               _buildListTile(context: context, icon: Icons.location_on_outlined, title: 'العناوين المحفوظة', onTap: () { /* TODO */ }),
              _buildListTile(context: context, icon: Icons.favorite_border_outlined, title: 'الخدمات المفضلة', onTap: () { /* TODO */ }),

              // --- App Components Navigation ---
              _buildGroupTitle(context, 'التطبيق'),
               _buildListTile(context: context, icon: Icons.settings_outlined, title: 'الإعدادات', route: AppRoutes.settings),
              _buildListTile(context: context, icon: Icons.support_agent_outlined, title: 'الدعم والمساعدة', route: AppRoutes.support),
               _buildListTile(context: context, icon: Icons.info_outline, title: 'عن التطبيق', route: AppRoutes.aboutUs),


              // --- Account Actions ---
               _buildGroupTitle(context, 'إدارة الحساب'),
               _buildListTile(
                   context: context,
                   icon: Icons.lock_outline,
                   title: 'تغيير كلمة المرور',
                   // Navigate to ResetPasswordScreen with isChangePassword flag
                   // OR create a dedicated ChangePasswordScreen if flow differs significantly
                   route: AppRoutes.changePassword,
              ),
              _buildListTile(
                   context: context,
                   icon: Icons.logout,
                   title: 'تسجيل الخروج',
                   color: AppColors.accent,
                   trailing: authState.isLoading ? const SizedBox(width:20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : null,
                   onTap: authState.isLoading ? null : () {
                      _showConfirmationDialog(
                         context: context,
                         title: 'تسجيل الخروج',
                         content: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                         confirmText: 'خروج',
                         onConfirm: () async { // Make async
                            try {
                              await authNotifier.logout();
                              // AuthWrapper will handle navigation automatically
                            } catch (e) {
                               // Error should be handled by listener in AuthWrapper or globally
                               print("Logout UI error: $e");
                            }
                         }
                      );
                   },
               ),
               _buildListTile(
                   context: context,
                   icon: Icons.delete_forever_outlined,
                   title: 'حذف الحساب',
                   color: AppColors.accent.withOpacity(0.8),
                   trailing: authState.isLoading ? const SizedBox(width:20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : null,
                   onTap: authState.isLoading ? null : () {
                      _showConfirmationDialog(
                         context: context,
                         title: 'حذف الحساب',
                         content: 'تحذير: سيتم حذف حسابك وجميع بياناتك نهائياً. هل أنت متأكد من المتابعة؟',
                         confirmText: 'حذف نهائي',
                         onConfirm: () async { // Make async
                            // TODO: Implement call to delete account in AuthNotifier/Repository
                             print("Account Deletion Placeholder");
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete Account - Placeholder')));
                             // On success, call logout to clear state & navigate
                             // await authNotifier.deleteAccount();
                             // await authNotifier.logout();
                         }
                      );
                   },
               ),
               const SizedBox(height: 20),
            ],
           ),
         ),
      ),
    );
  }
}
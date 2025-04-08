import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../core/constants/app_colors.dart';
import 'menu_item.dart';

// Placeholder for app settings provider (you'll create this later)
final appSettingsProvider = StateProvider<Locale>((ref) => const Locale('ar')); // Default to Arabic

class ProfileScreen extends ConsumerStatefulWidget {
  static const String route = '/profile';
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  // Placeholder - Replace with actual user data from a provider
  String _userName = "خالد الزعبي";
  String _userPhone = "+123 123 4569 99";
  String? _userAvatarUrl; // = "https://via.placeholder.com/150"; // Example URL

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currentLocale = ref.watch(appSettingsProvider); // Watch the language setting

    const double screenPadding = 16.0;
    const double avatarRadius = 50.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('حسابي الشخصي'),
        // Potentially add actions if needed
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(screenPadding),
          child: Column(
            children: [
              // --- User Info Section ---
              _buildUserInfoSection(context, avatarRadius, textTheme),
              const SizedBox(height: 30),

              // --- Menu Items ---
              _buildMenuItems(context, currentLocale),

            ],
          ),
        ),
      ),
    );
  }

  // --- User Info Widget ---
  Widget _buildUserInfoSection(BuildContext context, double radius, TextTheme textTheme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight, // For the edit icon
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: AppColors.lightGrey.withOpacity(0.5), // Placeholder bg
              backgroundImage: _userAvatarUrl != null ? NetworkImage(_userAvatarUrl!) : null,
              child: _userAvatarUrl == null
                  ? Icon(Icons.person_outline, size: radius, color: AppColors.grey) // Placeholder icon
                  : null,
            ),
            // Edit Icon Button
            Positioned(
              right: 0,
              bottom: 0,
              child: Material( // Wrap with Material for InkWell splash effect if desired
                color: AppColors.primary,
                shape: const CircleBorder(),
                elevation: 0, // No shadow as per theme
                child: InkWell(
                   borderRadius: BorderRadius.circular(20),
                   onTap: () {
                      // TODO: Implement image picking logic
                      print("Edit profile picture tapped");
                   },
                   child: const Padding(
                     padding: EdgeInsets.all(6.0),
                     child: Icon(
                       Icons.camera_alt,
                       color: AppColors.black, // Black icon on amber bg
                       size: 18,
                     ),
                   ),
                 ),
              )
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _userName,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          _userPhone,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }

  // --- Menu Items Widget ---
  Widget _buildMenuItems(BuildContext context, Locale currentLocale) {
    const iconChevron = Icon(Icons.chevron_left, color: AppColors.grey, size: 20); // Use chevron_right for LTR
    final String currentLanguage = currentLocale.languageCode == 'ar' ? 'العربية' : 'English';

    return Column(
      children: [
         ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: 'المعلومات الشخصية',
          trailing: iconChevron,
          onTap: () {
            // TODO: Navigate to Edit Profile Screen
            print("Navigate to Personal Info");
          },
        ),
        ProfileMenuItem(
          icon: Icons.receipt_long_outlined, // Or list_alt, shopping_bag_outlined
          title: 'طلباتي', // Replaced 'Balance'
          trailing: iconChevron,
          onTap: () {
            // TODO: Navigate to My Orders Screen
            print("Navigate to My Orders");
          },
        ),
         ProfileMenuItem(
          icon: Icons.lock_outline,
          title: 'تغيير كلمة المرور',
          trailing: iconChevron,
          onTap: () {
             // TODO: Navigate to Change Password Screen
            print("Navigate to Change Password");
          },
        ),
        ProfileMenuItem(
          icon: Icons.translate_outlined,
          title: 'اللغات',
          trailing: Text(currentLanguage, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey)),
          onTap: () {
            _showLanguageBottomSheet(context, ref);
          },
        ),

        const Divider(height: 20, thickness: 1, indent: 10, endIndent: 10), // Separator

        ProfileMenuItem(
          icon: Icons.headset_mic_outlined,
          title: 'تواصل مع خدمة العملاء',
          trailing: iconChevron,
          onTap: () {
            // TODO: Implement contact action (e.g., open chat, phone call)
            print("Contact Customer Support");
          },
        ),
        ProfileMenuItem(
          icon: Icons.shield_outlined,
          title: 'سياسة الخصوصية وشروط الاستخدام',
          trailing: iconChevron,
          onTap: () {
            // TODO: Navigate to Policy/Terms Screen or WebView
            print("Navigate to Policy/Terms");
          },
        ),

        const Divider(height: 20, thickness: 1, indent: 10, endIndent: 10), // Separator

        ProfileMenuItem(
          icon: Icons.delete_outline,
          title: 'حذف الحساب',
          textColor: Colors.red, // Make it red for caution
          iconColor: Colors.red,
          trailing: iconChevron,
          onTap: () {
            // TODO: Show confirmation dialog for delete account
            print("Delete Account Tapped");
            _showConfirmationDialog(context, 'حذف الحساب', 'هل أنت متأكد من رغبتك في حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.', () {
                // TODO: Implement account deletion logic
                print("Account Deletion Confirmed");
            });
          },
        ),
         ProfileMenuItem(
          icon: Icons.logout,
          title: 'تسجيل الخروج',
           textColor: Colors.red, // Make it red for caution
           iconColor: Colors.red,
          onTap: () {
             // TODO: Show confirmation dialog for logout
             print("Logout Tapped");
              _showConfirmationDialog(context, 'تسجيل الخروج', 'هل أنت متأكد من رغبتك في تسجيل الخروج؟', () {
                  // TODO: Implement logout logic (clear auth state, navigate to welcome/login)
                  print("Logout Confirmed");
              });
          },
        ),
      ],
    );
  }


  // --- Language Selection Bottom Sheet ---
  void _showLanguageBottomSheet(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(appSettingsProvider); // Read initial value

    // Temporary state holder for the bottom sheet selection
    Locale selectedLocale = currentLocale;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder( // Optional: Rounded corners for bottom sheet
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      // isScrollControlled: true, // Use if content might exceed half screen height
      builder: (BuildContext context) {
        // Use StatefulBuilder to manage the temporary selection state locally
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Take only needed height
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'تغيير لغة التطبيق', // Change App Language
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  RadioListTile<Locale>(
                    title: const Text('العربية'),
                    value: const Locale('ar'),
                    groupValue: selectedLocale,
                    onChanged: (Locale? value) {
                      if (value != null) {
                        setModalState(() {
                          selectedLocale = value;
                        });
                      }
                    },
                    activeColor: AppColors.primary, // Use theme color
                  ),
                  RadioListTile<Locale>(
                    title: const Text('English'),
                    value: const Locale('en'),
                    groupValue: selectedLocale,
                    onChanged: (Locale? value) {
                      if (value != null) {
                        setModalState(() {
                          selectedLocale = value;
                        });
                      }
                    },
                     activeColor: AppColors.primary,
                  ),
                  // Optional: System Language (might require more setup)
                  // RadioListTile<Locale?>(
                  //   title: const Text('لغة النظام'), // System Language
                  //   value: null, // Represent system choice with null or specific value
                  //   groupValue: selectedLocale,
                  //   onChanged: (Locale? value) {
                  //      setModalState(() {
                  //         selectedLocale = value;
                  //       });
                  //   },
                  //    activeColor: AppColors.primary,
                  // ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    // Style follows theme automatically
                    child: const Text('حفظ'), // Save
                    onPressed: () {
                      // Update the actual app state via Riverpod provider
                      ref.read(appSettingsProvider.notifier).state = selectedLocale;
                      // TODO: Persist this setting (e.g., using SharedPreferences)
                      // TODO: Apply the language change (might need app restart or locale update mechanism)
                      print("Language selected: ${selectedLocale.languageCode}");
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  ),
                   const SizedBox(height: 10), // Padding at bottom
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Confirmation Dialog ---
  void _showConfirmationDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)), // Low radius
          title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          content: Text(content, style: Theme.of(context).textTheme.bodyMedium),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'), // Cancel
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'تأكيد', // Confirm
                 style: TextStyle(color: title.contains('حذف') ? Colors.red : AppColors.primary), // Red for delete
               ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog first
                onConfirm(); // Execute the confirm action
              },
            ),
          ],
        );
      },
    );
  }

}
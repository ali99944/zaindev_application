import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import 'auth_providers.dart';


class ResetPasswordScreen extends ConsumerWidget {
  final String contactInfo;
  final String otpOrToken;
  final bool isChangePassword;

  const ResetPasswordScreen({
    super.key,
    required this.contactInfo,
    required this.otpOrToken,
    this.isChangePassword = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();

    // Use local loading provider
    final isLoading = ref.watch(resetPasswordLoadingProvider);
    final newPasswordVisible = ref.watch(newPasswordVisibleProvider);
    final confirmNewPasswordVisible = ref.watch(confirmNewPasswordVisibleProvider);

    final newPasswordController = TextEditingController(text: ref.watch(newPasswordProvider));
    final confirmPasswordController = TextEditingController(text: ref.watch(confirmNewPasswordProvider));

    void handleResetPassword() async { // Make async
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();
        final newPassword = ref.read(newPasswordProvider);
        final confirmPassword = ref.read(confirmNewPasswordProvider); // Read confirm password

        ref.read(resetPasswordLoadingProvider.notifier).state = true;

        try {
           // Call repository method
           await ref.read(authRepositoryProvider).resetPassword(
             identifier: contactInfo,
             code: otpOrToken, // Pass the OTP/token received
             password: newPassword,
             passwordConfirmation: confirmPassword,
           );

           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('تم تحديث كلمة المرور بنجاح!'), backgroundColor: Colors.green),
           );

           if (isChangePassword) {
             Navigator.pop(context); // Go back (e.g., from Profile)
           } else {
             // Navigate to Login after successful reset
             Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
           }

        } catch (e) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(e.toString()), backgroundColor: AppColors.accent),
           );
        } finally {
          ref.read(resetPasswordLoadingProvider.notifier).state = false;
        }
      }
    }

    return Directionality(
       textDirection: TextDirection.rtl,
       child: Scaffold(
         appBar: AppBar(title: Text(isChangePassword ? 'تغيير كلمة المرور' : 'تعيين كلمة مرور جديدة')),
         body: Padding(
           padding: const EdgeInsets.all(24.0),
           child: Form(
             key: formKey,
             child: Column(
               // ... (Layout is the same as previous version) ...
                children: [
                  const Icon(Icons.password_outlined, size: 80, color: AppColors.primary),
                  const SizedBox(height: 20),
                  Text('كلمة المرور الجديدة', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text('أدخل كلمة المرور الجديدة لحسابك.', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                  const SizedBox(height: 32),

                  // New Password Field
                   TextFormField(
                    controller: newPasswordController,
                    obscureText: !newPasswordVisible,
                     textDirection: TextDirection.ltr,
                     textAlign: TextAlign.right,
                    decoration: InputDecoration( /* ... (decoration as before) ... */),
                     validator: (value) {
                      if (value == null || value.isEmpty) return 'الحقل مطلوب';
                      if (value.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
                      return null;
                    },
                     onChanged: (value) => ref.read(newPasswordProvider.notifier).state = value,
                  ),
                 const SizedBox(height: 16),

                 // Confirm New Password Field
                   TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !confirmNewPasswordVisible,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration( /* ... (decoration as before) ... */),
                     validator: (value) {
                      if (value == null || value.isEmpty) return 'الحقل مطلوب';
                      if (value != newPasswordController.text) return 'كلمتا المرور غير متطابقتين';
                      return null;
                    },
                      onChanged: (value) => ref.read(confirmNewPasswordProvider.notifier).state = value,
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                     onPressed: isLoading ? null : handleResetPassword,
                     child: isLoading
                         ? const SizedBox(
                          height: 24,
                         )
                         : Text(isChangePassword ? 'تغيير كلمة المرور' : 'تعيين كلمة المرور'),
                   ),
               ],
             ),
           ),
         ),
       ),
    );
  }
}
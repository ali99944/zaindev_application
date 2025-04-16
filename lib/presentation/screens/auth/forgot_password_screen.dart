import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import 'auth_providers.dart'; // Import providers

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();

    // Use local loading provider for this specific action
    final isLoading = ref.watch(forgotPasswordLoadingProvider);
    final contactController = TextEditingController(text: ref.watch(forgotPasswordContactProvider));

    void handleSendOtp() async {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();
        final identifier = ref.read(forgotPasswordContactProvider);
        // Update local loading state
        ref.read(forgotPasswordLoadingProvider.notifier).state = true;

        try {
          // Call repository method directly
          await ref.read(authRepositoryProvider).sendPasswordResetOtp(identifier);

          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('تم إرسال رمز التحقق بنجاح.'), backgroundColor: Colors.green),
          );
          // Navigate to OTP screen on success
          Navigator.pushNamed(
            context,
            AppRoutes.otpVerification,
            arguments: {'contact': identifier, 'type': 'password_reset'},
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppColors.accent),
          );
        } finally {
          // Ensure loading state is reset
          ref.read(forgotPasswordLoadingProvider.notifier).state = false;
        }
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('نسيت كلمة المرور')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              // ... (Layout is the same as previous version) ...
               children: [
                const Icon(Icons.lock_reset_outlined, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),
                Text('إعادة تعيين كلمة المرور', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text('أدخل البريد الإلكتروني أو رقم الهاتف المرتبط بحسابك لإرسال رمز التحقق.', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                TextFormField(
                   controller: contactController,
                   keyboardType: TextInputType.text,
                   textDirection: TextDirection.ltr,
                   textAlign: TextAlign.right,
                   decoration: const InputDecoration(labelText: 'البريد الإلكتروني أو رقم الهاتف'),
                   validator: (value) => (value == null || value.isEmpty) ? 'الحقل مطلوب' : null,
                   onChanged: (value) => ref.read(forgotPasswordContactProvider.notifier).state = value,
                 ),
                 const SizedBox(height: 32),
                 ElevatedButton(
                   onPressed: isLoading ? null : handleSendOtp,
                   child: isLoading
                       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                       : const Text('إرسال رمز التحقق'),
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
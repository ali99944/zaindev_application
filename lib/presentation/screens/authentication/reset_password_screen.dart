import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/app_alert_dialog.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/textform_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  static const String route = "/reset-password";
   final Map<String, dynamic> arguments; // Expects {'token': String}

  const ResetPasswordScreen({super.key, required this.arguments});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  late String _verificationToken;

  @override
  void initState() {
      super.initState();
      _verificationToken = widget.arguments['token'] ?? '';
      if (_verificationToken.isEmpty) {
         // Handle error: If no token is passed, maybe navigate back or show error
         WidgetsBinding.instance.addPostFrameCallback((_) {
             showAppDialog(
               context: context,
               dialogType: DialogType.error,
               title: "خطأ",
               message: "حدث خطأ غير متوقع. رمز التحقق غير صالح.",
               onOkPressed: () => Navigator.pop(context) // Go back
             );
         });
      }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    // --- TODO: Implement Reset Password API Call ---
    // Pass _verificationToken and new password to the API
    // final success = await ref.read(authRepositoryProvider).resetPassword(
    //   token: _verificationToken,
    //   newPassword: _newPasswordController.text,
    // );
     print('Resetting password with token: $_verificationToken');
     await Future.delayed(const Duration(seconds: 1)); // Simulate network
     bool success = true; // Assume success
    // --- End API Call ---

    setState(() => _isLoading = false);

     if (mounted) {
       if (success) {
         showAppDialog(
           context: context,
           dialogType: DialogType.success,
           title: 'تم تغيير كلمة المرور',
           message: 'تم تحديث كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.',
           onOkPressed: () {
             // Navigate to Login, clearing the stack
             Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
           }
         );
       } else {
          showAppDialog(
           context: context,
           dialogType: DialogType.error,
           title: 'فشل التحديث',
           message: 'لم نتمكن من تحديث كلمة المرور. قد يكون رمز التحقق منتهي الصلاحية. يرجى المحاولة مرة أخرى.',
         );
       }
     }
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعيين كلمة مرور جديدة'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const Icon(Icons.password_rounded, size: 60, color: AppColors.primary),
                  const SizedBox(height: 20),
                  Text(
                    'إدخال كلمة مرور جديدة',
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور السابقة.',
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // New Password
                   CustomTextFormField(
                    controller: _newPasswordController,
                    labelText: 'كلمة المرور الجديدة',
                    prefixIconData: Icons.lock_outline,
                    obscureText: !_isNewPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(_isNewPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.grey),
                      onPressed: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
                    ),
                     validator: (value) {
                      if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة المرور الجديدة';
                      if (value.length < 8) return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Confirm New Password
                   CustomTextFormField(
                    controller: _confirmPasswordController,
                    labelText: 'تأكيد كلمة المرور الجديدة',
                    prefixIconData: Icons.lock_outline,
                    obscureText: !_isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.grey),
                      onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    ),
                     validator: (value) {
                      if (value == null || value.isEmpty) return 'الرجاء تأكيد كلمة المرور الجديدة';
                      if (value != _newPasswordController.text) return 'كلمتا المرور غير متطابقتين';
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _isLoading ? null : _resetPassword(),
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  PrimaryButton(
                    onPressed: _resetPassword,
                    text: 'تحديث كلمة المرور',
                    isLoading: _isLoading,
                    minWidth: double.infinity,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
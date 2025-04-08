import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../core/constants/app_colors.dart';
import '../../widgets/app_alert_dialog.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/textform_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const String route = "/forgot-password";
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);
    final String emailOrPhone = _emailOrPhoneController.text;

    // --- TODO: Implement Send OTP API Call ---
    // final success = await ref.read(authRepositoryProvider).requestPasswordResetOtp(emailOrPhone);
    print('Requesting OTP for: $emailOrPhone');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    bool success = true; // Assume success for now
    // --- End API Call ---

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        // Navigate to OTP screen, passing the email/phone for verification context
        Navigator.pushNamed(
          context,
          'otp',
          arguments: {'emailOrPhone': emailOrPhone, 'reason': 'resetPassword'}, // Pass context
        );
      } else {
        showAppDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'فشل الإرسال',
          message: 'لم نتمكن من إرسال رمز التحقق. يرجى التحقق من البريد الإلكتروني أو رقم الهاتف والمحاولة مرة أخرى.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('نسيت كلمة المرور'),
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
                 const Icon(Icons.lock_reset_outlined, size: 60, color: AppColors.primary),
                 const SizedBox(height: 20),
                Text(
                  'إعادة تعيين كلمة المرور',
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 10),
                 Text(
                  'أدخل البريد الإلكتروني أو رقم الهاتف المرتبط بحسابك وسنرسل لك رمز تحقق لإعادة تعيين كلمة المرور.',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomTextFormField(
                  controller: _emailOrPhoneController,
                  labelText: 'البريد الإلكتروني أو رقم الهاتف',
                  prefixIconData: Icons.person_outline,
                  keyboardType: TextInputType.emailAddress, // Can adjust based on input type detection
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الحقل مطلوب';
                    }
                    // Basic check - enhance if needed
                    // bool isEmail = value.contains('@');
                    // bool isPhone = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value);
                    // if (!isEmail && !isPhone) {
                    //   return 'الرجاء إدخال بريد إلكتروني أو رقم هاتف صالح';
                    // }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _isLoading ? null : _sendOtp(),
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  onPressed: _sendOtp,
                  text: 'إرسال رمز التحقق',
                  isLoading: _isLoading,
                  minWidth: double.infinity,
                ),
                 const SizedBox(height: 20),
                 TextButton(
                   onPressed: () => Navigator.pop(context), // Go back to Login
                   child: const Text('العودة إلى تسجيل الدخول'),
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import 'auth_providers.dart'; // Import providers
// Optional: Import pinput package if you use it
// import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String contactInfo;
  final String verificationType;

  const OtpVerificationScreen({
    super.key,
    required this.contactInfo,
    required this.verificationType,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  Timer? _timer;
  final otpController = TextEditingController(); // Controller for OTP field

  @override
  void initState() {
    super.initState();
    startTimer();
    // Listen to provider for external updates if needed
    otpController.text = ref.read(otpCodeProvider);
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void startTimer() { /* ... (Same as previous version) ... */ }

  void handleResendOtp() async { // Make async
    if (ref.read(otpCanResendProvider)) {
      startTimer();
      try {
         // Call repository method
         await ref.read(authRepositoryProvider).sendPasswordResetOtp(widget.contactInfo);
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إعادة إرسال الرمز.'), backgroundColor: Colors.green),
        );
      } catch (e) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.accent),
        );
      }
    }
  }

  void handleVerifyOtp() async { // Make async
    final otpCode = ref.read(otpCodeProvider);
    if (otpCode.length != 6) { /* ... (Validation as before) ... */ return; }

    ref.read(otpLoadingProvider.notifier).state = true;
    try {
      // Call repository method (Optional: API might not need separate verify step)
      // await ref.read(authRepositoryProvider).verifyPasswordResetOtp(widget.contactInfo, otpCode);

      // Proceed directly to next step (Reset Password) after successful verification
      // The backend reset password endpoint should re-verify the OTP
      if (widget.verificationType == 'password_reset') {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.resetPassword,
          arguments: {'contact': widget.contactInfo, 'otpOrToken': otpCode},
        );
      } else {
        // Handle other types (e.g., account activation)
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التحقق بنجاح!'), backgroundColor: Colors.green),
        );
        // Potentially log the user in or navigate home
        // await ref.read(authNotifierProvider.notifier).login(...) or similar action
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeNavigator, (route) => false);
      }

    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(e.toString()), backgroundColor: AppColors.accent),
       );
    } finally {
       ref.read(otpLoadingProvider.notifier).state = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLoading = ref.watch(otpLoadingProvider);
    final timerValue = ref.watch(otpResendTimerProvider);
    final canResend = ref.watch(otpCanResendProvider);
    // No need for separate controller, use otpController declared in state

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
         appBar: AppBar(title: const Text('التحقق من الرمز')),
         body: Padding(
          padding: const EdgeInsets.all(24.0),
           child: Column(
             // ... (Layout is the same as previous version) ...
             children: [
               const Icon(Icons.phonelink_lock_outlined, size: 80, color: AppColors.primary),
               const SizedBox(height: 20),
               Text('أدخل رمز التحقق', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
               const SizedBox(height: 12),
               Text('تم إرسال رمز مكون من 6 أرقام إلى\n${widget.contactInfo}', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
               const SizedBox(height: 32),

               // OTP Input Field
               TextFormField( // Use TextFormField for easier integration with Form if needed later
                 controller: otpController,
                 maxLength: 6,
                 keyboardType: TextInputType.number,
                 textAlign: TextAlign.center,
                 style: textTheme.headlineMedium?.copyWith(letterSpacing: 10),
                 decoration: const InputDecoration(
                    counterText: "",
                    hintText: '------',
                    border: OutlineInputBorder(),
                 ),
                 onChanged: (value) => ref.read(otpCodeProvider.notifier).state = value,
                 validator: (v) => (v == null || v.length != 6) ? 'أدخل 6 أرقام' : null,
               ),
               // Consider 'pinput' package here

               const SizedBox(height: 24),
               ElevatedButton(
                 onPressed: isLoading ? null : handleVerifyOtp,
                 child: isLoading
                     ? const SizedBox(height: 24,) : const Text('تحقق'),
               ),
               const SizedBox(height: 24),

               // Resend OTP
               Row( /* ... (Resend Row as before) ... */),
             ],
           ),
         ),
      ),
    );
  }
}
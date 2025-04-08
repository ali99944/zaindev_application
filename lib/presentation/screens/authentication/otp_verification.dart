import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/app_alert_dialog.dart';
import '../../widgets/primary_button.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  static const String route = "/otp";
  final Map<String, dynamic> arguments; // Expects {'emailOrPhone': String, 'reason': String}

  const OtpVerificationScreen({super.key, required this.arguments});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  StreamController<ErrorAnimationType>? _errorController;

  bool _isLoading = false;
  int _resendTimerSeconds = 60; // Timer duration
  Timer? _timer;
  bool _canResend = false;

  late String _emailOrPhone;
  late String _reason; // e.g., 'resetPassword', 'verifyAccount'

  @override
  void initState() {
    super.initState();
    _emailOrPhone = widget.arguments['emailOrPhone'] ?? 'المستخدم';
    _reason = widget.arguments['reason'] ?? 'Verification';
    _errorController = StreamController<ErrorAnimationType>();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _errorController?.close();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _resendTimerSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimerSeconds == 0) {
        if (mounted) {
          setState(() {
            _timer?.cancel();
            _canResend = true;
          });
        }
      } else {
         if (mounted) {
           setState(() {
            _resendTimerSeconds--;
           });
         }
      }
    });
  }

  String _maskContactInfo(String info) {
     // Simple masking, improve as needed
     if (info.contains('@')) { // Email
        final parts = info.split('@');
        if (parts[0].length > 3) {
           return '${parts[0].substring(0,3)}***@${parts[1]}';
        }
        return '***@${parts[1]}';
     } else { // Phone
        if (info.length > 4) {
            return '******${info.substring(info.length - 4)}';
        }
        return '******';
     }
  }


  Future<void> _verifyOtp() async {
    _formKey.currentState!.validate(); // Trigger validation display if needed
    String currentOtp = _otpController.text;
    if (currentOtp.length != 6) { // Assuming 6-digit OTP
      _errorController?.add(ErrorAnimationType.shake); // Trigger shake animation
      return;
    }

    setState(() => _isLoading = true);

    // --- TODO: Implement Verify OTP API Call ---
    // Pass _emailOrPhone, currentOtp, and _reason to the API
    // final result = await ref.read(authRepositoryProvider).verifyOtp(
    //   contactInfo: _emailOrPhone,
    //   otp: currentOtp,
    //   reason: _reason,
    // );
    print('Verifying OTP: $currentOtp for $_emailOrPhone (Reason: $_reason)');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    bool success = currentOtp != '000000'; // Simulate success/fail
    String? verificationToken; // Get token from backend if verification is successful
    if (success) verificationToken = "dummy_verification_token_123";
    // --- End API Call ---

    setState(() => _isLoading = false);

     if (mounted) {
      if (success && verificationToken != null) {
        if (_reason == 'resetPassword') {
          // Navigate to Reset Password screen, passing the token
          Navigator.pushReplacementNamed(
              context,
              '/reset-password',
              arguments: {'token': verificationToken}, // Pass necessary token
           );
        } else {
           // Handle other verification reasons (e.g., verify account after registration)
           // Maybe navigate home or show success message
           Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } else {
         _errorController?.add(ErrorAnimationType.shake);
         showAppDialog(
           context: context,
           dialogType: DialogType.error,
           title: 'رمز تحقق غير صالح',
           message: 'الرمز الذي أدخلته غير صحيح أو منتهي الصلاحية. حاول مرة أخرى أو اطلب رمزًا جديدًا.',
         );
      }
    }
  }

  Future<void> _resendOtp() async {
     if (!_canResend) return;

     setState(() => _isLoading = true); // Optional: show loading on resend button

     // --- TODO: Implement Resend OTP API Call (use same endpoint as forgot password?) ---
     // final success = await ref.read(authRepositoryProvider).requestPasswordResetOtp(_emailOrPhone);
     print('Resending OTP to: $_emailOrPhone');
     await Future.delayed(const Duration(seconds: 1));
     bool success = true;
     // --- End API Call ---

      setState(() => _isLoading = false);

      if(mounted) {
        if (success) {
           showAppDialog(
             context: context,
             dialogType: DialogType.info,
             title: 'تم إرسال الرمز',
             message: 'تم إرسال رمز تحقق جديد إلى ${_maskContactInfo(_emailOrPhone)}.',
           );
           _otpController.clear(); // Clear previous input
           _startTimer(); // Restart timer
        } else {
          showAppDialog(
             context: context,
             dialogType: DialogType.error,
             title: 'فشل الإرسال',
             message: 'لم نتمكن من إعادة إرسال رمز التحقق. يرجى المحاولة مرة أخرى لاحقاً.',
           );
        }
      }
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من الرمز'),
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
                const Icon(Icons.security_outlined, size: 60, color: AppColors.primary),
                const SizedBox(height: 20),
                Text(
                  'أدخل رمز التحقق',
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'لقد أرسلنا رمز تحقق مكون من 6 أرقام إلى ${_maskContactInfo(_emailOrPhone)}. الرجاء إدخاله أدناه.',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 40),

                // --- Pin Code Fields ---
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box, // Or .underline, .circle
                    borderRadius: BorderRadius.circular(6), // Low radius
                    fieldHeight: 50,
                    fieldWidth: 45,
                    borderWidth: 1.5,
                    activeFillColor: AppColors.white,
                    inactiveFillColor: AppColors.white,
                    selectedFillColor: AppColors.white,
                    activeColor: AppColors.primary, // Border color when active
                    inactiveColor: AppColors.lightGrey, // Border color when inactive
                    selectedColor: AppColors.primary, // Border color when selected
                  ),
                  cursorColor: AppColors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: _errorController,
                  keyboardType: TextInputType.number,
                  boxShadows: const [ // Remove default shadows
                    BoxShadow(offset: Offset(0, 0), blurRadius: 0, color: Colors.transparent)
                  ],
                  onCompleted: (v) {
                    print("Completed: $v");
                    _verifyOtp(); // Auto-verify on completion
                  },
                  onChanged: (value) {
                    // print(value);
                  },
                  beforeTextPaste: (text) {
                    // Allow pasting
                    return true;
                  },
                ),
                 const SizedBox(height: 30),

                // --- Verify Button ---
                 PrimaryButton(
                  onPressed: _verifyOtp,
                  text: 'تحقق',
                  isLoading: _isLoading,
                  minWidth: double.infinity,
                ),
                const SizedBox(height: 25),

                // --- Resend Code ---
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      Text('لم تستلم الرمز؟', style: textTheme.bodyMedium),
                      TextButton(
                        onPressed: _canResend ? _resendOtp : null, // Enable only when timer finishes
                        child: Text(
                          _canResend
                             ? 'إعادة الإرسال'
                             : 'إعادة الإرسال بعد ($_resendTimerSeconds)',
                           style: TextStyle(color: _canResend ? AppColors.primary : AppColors.grey),
                        ),
                      ),
                   ],
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
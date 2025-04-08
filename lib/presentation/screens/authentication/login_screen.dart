import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/app_alert_dialog.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/textform_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String route = "/login";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if validation fails
    }
    setState(() => _isLoading = true);

    // --- TODO: Implement Login API Call ---
    // final authNotifier = ref.read(authProvider.notifier);
    // final success = await authNotifier.login(
    //   emailOrPhone: _emailOrPhoneController.text,
    //   password: _passwordController.text,
    // );
    print("Email/Phone: ${_emailOrPhoneController.text}");
    print("Password: ${_passwordController.text}");
    await Future.delayed(const Duration(seconds: 2)); // Simulate network
    bool success = _passwordController.text != 'fail'; // Simulate success/fail
    // --- End API Call ---

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        // Navigate to Home and remove login/welcome/onboarding stack
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        showAppDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'فشل تسجيل الدخول',
          message: 'البريد الإلكتروني/رقم الهاتف أو كلمة المرور غير صحيحة.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
       // Optional: Add AppBar if design requires
       // appBar: AppBar(title: const Text('تسجيل الدخول')),
       body: SafeArea(
         child: Center( // Center content vertically
           child: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
               child: Form(
                 key: _formKey,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     // --- Logo ---
                     Image.asset(
                       'assets/images/zain_logo.png', // Ensure logo exists
                       height: size.height * 0.12,
                     ),
                     const SizedBox(height: 30),

                     // --- Title ---
                     Text(
                       'تسجيل الدخول',
                       style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                       textAlign: TextAlign.center,
                     ),
                      Text(
                       'مرحباً بعودتك! قم بتسجيل الدخول للمتابعة',
                       style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                       textAlign: TextAlign.center,
                     ),
                     const SizedBox(height: 30),

                     // --- Email or Phone Field ---
                     CustomTextFormField(
                       controller: _emailOrPhoneController,
                       labelText: 'البريد الإلكتروني أو رقم الهاتف',
                       prefixIconData: Icons.person_outline,
                       keyboardType: TextInputType.emailAddress, // Adjust if needed
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'الرجاء إدخال البريد الإلكتروني أو رقم الهاتف';
                         }
                         // Add more specific email/phone validation if needed
                         return null;
                       },
                       textInputAction: TextInputAction.next,
                     ),
                     const SizedBox(height: 20),

                     // --- Password Field ---
                     CustomTextFormField(
                       controller: _passwordController,
                       labelText: 'كلمة المرور',
                       prefixIconData: Icons.lock_outline,
                       obscureText: !_isPasswordVisible,
                       suffixIcon: IconButton(
                         icon: Icon(
                           _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                           color: AppColors.grey,
                         ),
                         onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                       ),
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'الرجاء إدخال كلمة المرور';
                         }
                         return null;
                       },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _isLoading ? null : _login(),
                     ),
                     const SizedBox(height: 15),

                     // --- Forgot Password ---
                     Align(
                       alignment: AlignmentDirectional.centerEnd,
                       child: TextButton(
                         onPressed: () {
                           // TODO: Navigate to Forgot Password Screen
                           print('Forgot Password Tapped');
                         },
                         child: const Text('هل نسيت كلمة المرور؟'),
                       ),
                     ),
                     const SizedBox(height: 25),

                     // --- Login Button ---
                     PrimaryButton(
                       onPressed: _login,
                       text: 'تسجيل الدخول',
                       isLoading: _isLoading,
                       minWidth: double.infinity,
                     ),
                     const SizedBox(height: 20),

                     // --- Register Link ---
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text('ليس لديك حساب؟', style: textTheme.bodyMedium),
                         TextButton(
                           onPressed: () {
                              Navigator.pushNamed(context, 'register'); // Navigate to Register
                           },
                           child: const Text('إنشاء حساب جديد'),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
             ),
           ),
         ),
       ),
    );
  }
}
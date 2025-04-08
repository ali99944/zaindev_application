import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/presentation/screens/authentication/login_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/app_alert_dialog.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/step_indicator.dart';
import '../../widgets/textform_field.dart'; // Import step indicator

class RegisterScreen extends ConsumerStatefulWidget {
  static const String route = "/register";
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0; // 0 for basic info, 1 for password
  final int _totalSteps = 2;

  // Step 1 Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2 Controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  Future<void> _register() async {
     if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if validation fails
    }
    setState(() => _isLoading = true);

    // --- TODO: Implement Registration API Call ---
    // final authNotifier = ref.read(authProvider.notifier);
    // final success = await authNotifier.register(
    //   name: _nameController.text,
    //   email: _emailController.text,
    //   phone: _phoneController.text,
    //   password: _passwordController.text,
    // );
     print("Name: ${_nameController.text}");
     print("Email: ${_emailController.text}");
     print("Phone: ${_phoneController.text}");
     print("Password: ${_passwordController.text}");
     await Future.delayed(const Duration(seconds: 2)); // Simulate network
     bool success = true; // Assume success
    // --- End API Call ---

     setState(() => _isLoading = false);

      if (mounted) {
      if (success) {
        showAppDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'تم إنشاء الحساب',
          message: 'تم إنشاء حسابك بنجاح. يمكنك الآن تسجيل الدخول.',
          onOkPressed: () {
             // Navigate to Login and remove registration stack
             Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (route) => false);
          }
        );
      } else {
        showAppDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'فشل إنشاء الحساب',
          message: 'حدث خطأ ما. قد يكون البريد الإلكتروني أو رقم الهاتف مستخدماً بالفعل.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
     final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        elevation: 0, // Consistent with theme
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Match background
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   // --- Step Indicator ---
                   Text(
                     _currentStep == 0 ? 'الخطوة 1: المعلومات الأساسية' : 'الخطوة 2: كلمة المرور',
                     style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                     textAlign: TextAlign.center,
                   ),
                   const SizedBox(height: 10),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 40.0), // Constrain width
                     child: StepIndicator(
                       numberOfSteps: _totalSteps,
                       currentStep: _currentStep,
                     ),
                   ),
                    const SizedBox(height: 30),

                   // --- Form Fields (Conditional) ---
                   if (_currentStep == 0) _buildStep1Fields()
                   else _buildStep2Fields(), // Show step 2 fields

                   const SizedBox(height: 40),

                   // --- Action Button ---
                    PrimaryButton(
                      onPressed: _currentStep == 0 ? _nextStep : _register,
                      text: _currentStep == 0 ? 'التالي' : 'إنشاء الحساب',
                      isLoading: _isLoading && _currentStep == 1, // Show loader only on final step
                      minWidth: double.infinity,
                    ),
                   const SizedBox(height: 20),

                   // --- Login Link ---
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text('لديك حساب بالفعل؟', style: textTheme.bodyMedium),
                         TextButton(
                           onPressed: () {
                              // Pop current screen and go to Login
                              Navigator.pop(context); // Or Navigator.pushReplacementNamed if appropriate
                           },
                           child: const Text('تسجيل الدخول'),
                         ),
                       ],
                     ),
                 ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget builder for Step 1 fields
  Widget _buildStep1Fields() {
    return Column(
      children: [
         CustomTextFormField(
          controller: _nameController,
          labelText: 'الاسم الكامل',
          prefixIconData: Icons.person_outline,
          validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال الاسم الكامل' : null,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          controller: _emailController,
          labelText: 'البريد الإلكتروني',
           prefixIconData: Icons.email_outlined,
          validator: (value) {
             if (value == null || value.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
             if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value)) {
                 return 'الرجاء إدخال بريد إلكتروني صالح';
             }
             return null;
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
         CustomTextFormField(
          controller: _phoneController,
          labelText: 'رقم الهاتف',
           prefixIconData: Icons.phone_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) return 'الرجاء إدخال رقم الهاتف';
            // Add more specific phone number validation if needed
            return null;
          },
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done, // Done on this step before hitting Next button
           onFieldSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

    // Widget builder for Step 2 fields
  Widget _buildStep2Fields() {
     return Column(
      children: [
        CustomTextFormField(
          controller: _passwordController,
          labelText: 'كلمة المرور',
          prefixIconData: Icons.lock_outline,
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.grey),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
           validator: (value) {
            if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة المرور';
            if (value.length < 8) return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        // Password requirements guide (Optional but helpful)
        Text(
          'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل.',
           style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 20),
         CustomTextFormField(
          controller: _confirmPasswordController,
          labelText: 'تأكيد كلمة المرور',
          prefixIconData: Icons.lock_outline,
          obscureText: !_isConfirmPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.grey),
            onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
          ),
           validator: (value) {
            if (value == null || value.isEmpty) return 'الرجاء تأكيد كلمة المرور';
            if (value != _passwordController.text) return 'كلمتا المرور غير متطابقتين';
            return null;
          },
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _isLoading ? null : _register(),
        ),
      ],
    );
  }
} // End of _RegisterScreenState
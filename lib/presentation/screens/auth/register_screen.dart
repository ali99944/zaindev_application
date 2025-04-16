import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import 'auth_providers.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();

    // Watch main auth state for loading status and errors
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Local UI state providers
    final nameController = TextEditingController(text: ref.watch(registerNameProvider));
    final emailController = TextEditingController(text: ref.watch(registerEmailProvider));
    final phoneController = TextEditingController(text: ref.watch(registerPhoneProvider));
    final passwordController = TextEditingController(text: ref.watch(registerPasswordProvider));
    final confirmPasswordController = TextEditingController(text: ref.watch(registerConfirmPasswordProvider));
    final passwordVisible = ref.watch(registerPasswordVisibleProvider);
    final confirmPasswordVisible = ref.watch(registerConfirmPasswordVisibleProvider);
    final termsAccepted = ref.watch(registerTermsAcceptedProvider);

    // --- Listener for Auth State Changes (Errors/Success) ---
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
       if (next.error != null && next.error != previous?.error) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(next.error!), backgroundColor: AppColors.accent),
         );
       }
       // Successful registration also handled by AuthWrapper navigation
    });

    // --- Register Handler ---
    void handleRegister() async {
      if (formKey.currentState?.validate() ?? false) {
        if (!termsAccepted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يجب الموافقة على الشروط وسياسة الخصوصية'), backgroundColor: AppColors.accent),
          );
          return;
        }

        // Read values from local providers
        final name = ref.read(registerNameProvider);
        final email = ref.read(registerEmailProvider);
        final phone = ref.read(registerPhoneProvider);
        final password = ref.read(registerPasswordProvider);
        final confirmPassword = ref.read(registerConfirmPasswordProvider);

        try {
          await authNotifier.register(
            name: name,
            email: email,
            phoneNumber: phone.isNotEmpty ? phone : null, // Pass phone only if entered
            password: password,
            passwordConfirmation: confirmPassword,
          );
           // Success: AuthWrapper will navigate
           ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إنشاء الحساب بنجاح!'), backgroundColor: Colors.green)
           );
        } catch (e) {
          // Error handled by listener
           print("Register UI Error: $e");
        }
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إنشاء حساب جديد'),
          elevation: 0,
          backgroundColor: AppColors.primary,
           automaticallyImplyLeading: false, // Remove back button
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                 Image.asset(AppAssets.logo, height: 60, color: AppColors.primary),
                 const SizedBox(height: 16),
                Text(
                  'مرحباً بك!',
                   style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 8),
                 Text(
                  'املأ البيانات التالية لإنشاء حساب جديد',
                   style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                 // Name Field
                TextFormField(
                   controller: nameController,
                   decoration: const InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person_outline)),
                   validator: (value) => (value == null || value.isEmpty) ? 'الاسم مطلوب' : null,
                   onChanged: (value) => ref.read(registerNameProvider.notifier).state = value,
                 ),
                 const SizedBox(height: 16),

                // Email Field
                 TextFormField(
                   controller: emailController,
                   keyboardType: TextInputType.emailAddress,
                   textDirection: TextDirection.ltr,
                   textAlign: TextAlign.right,
                   decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'صيغة البريد غير صحيحة';
                      return null;
                    },
                    onChanged: (value) => ref.read(registerEmailProvider.notifier).state = value,
                 ),
                 const SizedBox(height: 16),

                 // Phone Field (Optional)
                 TextFormField(
                   controller: phoneController,
                   keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                   decoration: const InputDecoration(labelText: 'رقم الهاتف (اختياري)', prefixIcon: Icon(Icons.phone_outlined)),
                   // No validator needed if optional, add specific format validation if required
                   onChanged: (value) => ref.read(registerPhoneProvider.notifier).state = value,
                 ),
                 const SizedBox(height: 16),

                 // Password Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                         icon: Icon(passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                         onPressed: () => ref.read(registerPasswordVisibleProvider.notifier).update((state) => !state),
                      ),
                    ),
                     validator: (value) {
                      if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
                      if (value.length < 8) return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'; // Increased minimum
                      return null;
                    },
                    onChanged: (value) => ref.read(registerPasswordProvider.notifier).state = value,
                  ),
                 const SizedBox(height: 16),

                 // Confirm Password Field
                   TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !confirmPasswordVisible,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                         icon: Icon(confirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                         onPressed: () => ref.read(registerConfirmPasswordVisibleProvider.notifier).update((state) => !state),
                      ),
                    ),
                     validator: (value) {
                      if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
                      if (value != passwordController.text) return 'كلمتا المرور غير متطابقتين';
                      return null;
                    },
                      onChanged: (value) => ref.read(registerConfirmPasswordProvider.notifier).state = value,
                  ),
                 const SizedBox(height: 16),

                 // Terms & Conditions Checkbox
                 Row(/* ... Copy Checkbox Row from previous RegisterScreen ... */),
                 const SizedBox(height: 24),

                  // Register Button
                  ElevatedButton(
                     onPressed: authState.isLoading ? null : handleRegister, // Use main auth loading state
                     child: authState.isLoading
                         ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                         : const Text('إنشاء الحساب'),
                   ),
                   const SizedBox(height: 24),

                   // Navigate to Login
                  Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text('لديك حساب بالفعل؟', style: textTheme.bodyMedium),
                       TextButton(
                         onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                         child: const Text('تسجيل الدخول'),
                       ),
                     ],
                   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
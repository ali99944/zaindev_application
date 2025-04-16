import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import 'auth_providers.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();

    // Watch main auth state for loading status and errors
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Use local providers for UI state like password visibility and field values
    final identifierController = TextEditingController(text: ref.watch(loginIdentifierProvider));
    final passwordController = TextEditingController(text: ref.watch(loginPasswordProvider));
    final passwordVisible = ref.watch(loginPasswordVisibleProvider);

    // --- Listener for Auth State Changes (Errors/Success) ---
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      // Show error SnackBar
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppColors.accent),
        );
      }
      // NOTE: Navigation on successful login is handled by AuthWrapper reacting
      // to the authState.isAuthenticated change. No explicit navigation needed here.
    });

    // --- Login Handler ---
    void handleLogin() async {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save(); // Optional if using controllers directly
        final identifier = ref.read(loginIdentifierProvider);
        final password = ref.read(loginPasswordProvider);

        // Call the notifier method
        try {
          await authNotifier.login(identifier, password);
          // Success: AuthWrapper will navigate
        } catch (e) {
          // Error is handled by the listener above
          print("Login UI Error: $e");
        }
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل الدخول'),
          elevation: 0,
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false, // Remove back button if pushed replacement
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Image.asset(AppAssets.logo, height: 70, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'أهلاً بعودتك!',
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'سجل الدخول للمتابعة إلى حسابك',
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Identifier Field
                TextFormField(
                  controller: identifierController,
                  keyboardType: TextInputType.text, // Allow email or phone
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني أو رقم الهاتف',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'الحقل مطلوب' : null,
                  onChanged: (value) => ref.read(loginIdentifierProvider.notifier).state = value,
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
                      onPressed: () => ref.read(loginPasswordVisibleProvider.notifier).update((state) => !state),
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'كلمة المرور مطلوبة' : null,
                  onChanged: (value) => ref.read(loginPasswordProvider.notifier).state = value,
                ),
                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : handleLogin, // Use main auth loading state
                  child: authState.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('تسجيل الدخول'),
                ),
                const SizedBox(height: 24),

                // Navigate to Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ليس لديك حساب؟', style: textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
                      child: const Text('إنشاء حساب جديد'),
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
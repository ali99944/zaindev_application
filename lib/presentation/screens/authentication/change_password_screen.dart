import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/textform_field.dart'; // Import custom button

class ChangePasswordScreen extends StatefulWidget {
  static const String route = "/change-password";
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // ... (rest of the class definition remains the same) ...
    @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ... (_submitForm method remains the same) ...
    Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // --- TODO: Implement API Call ---
      // Use Riverpod to call your auth repository/use case
      // Example:
      // final success = await ref.read(authRepositoryProvider).changePassword(
      //   currentPassword: _currentPasswordController.text,
      //   newPassword: _newPasswordController.text,
      // );
      await Future.delayed(const Duration(seconds: 1)); // Simulate network call
      bool success = true; // Assume success for now
      // --- End API Call ---

      setState(() => _isLoading = false);

      if (mounted) { // Check if widget is still in tree
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح'), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // Go back to previous screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('فشل تغيير كلمة المرور. يرجى المحاولة مرة أخرى.'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تغيير كلمة المرور'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('يرجى إدخال كلمة المرور الحالية والجديدة.', style: textTheme.bodyMedium?.copyWith(color: AppColors.grey)),
                const SizedBox(height: 30),

                // Current Password - Using CustomTextFormField
                CustomTextFormField(
                  controller: _currentPasswordController,
                  labelText: 'كلمة المرور الحالية',
                  prefixIconData: Icons.lock_outline,
                  obscureText: !_isCurrentPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.grey,
                    ),
                    onPressed: () => setState(() => _isCurrentPasswordVisible = !_isCurrentPasswordVisible),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور الحالية';
                    }
                    return null;
                  },
                   textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                // New Password - Using CustomTextFormField
                CustomTextFormField(
                  controller: _newPasswordController,
                  labelText: 'كلمة المرور الجديدة',
                  prefixIconData: Icons.lock_outline,
                  obscureText: !_isNewPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.grey,
                    ),
                    onPressed: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور الجديدة';
                    }
                    if (value.length < 8) {
                      return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
                    }
                     if (value == _currentPasswordController.text) {
                       return 'كلمة المرور الجديدة يجب أن تكون مختلفة عن الحالية';
                     }
                    return null;
                  },
                   textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                // Confirm New Password - Using CustomTextFormField
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور الجديدة',
                  prefixIconData: Icons.lock_outline,
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.grey,
                    ),
                    onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة المرور الجديدة';
                    }
                    if (value != _newPasswordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
                   textInputAction: TextInputAction.done,
                   onFieldSubmitted: (_) => _isLoading ? null : _submitForm(),
                ),
                const SizedBox(height: 40),

                // Submit Button - Using PrimaryButton
                PrimaryButton(
                  onPressed: _submitForm,
                  text: 'تحديث كلمة المرور',
                  isLoading: _isLoading,
                  minWidth: double.infinity, // Make button full width
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    // Need to declare controllers and visibility flags
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();

  final _newPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;

  bool _isNewPasswordVisible = false;

  bool _isConfirmPasswordVisible = false;

  bool _isLoading = false;
} // End of _ChangePasswordScreenState
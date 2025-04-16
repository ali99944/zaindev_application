import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

import '../../../core/constants/app_colors.dart';
// import 'package:url_launcher/url_launcher.dart';

// Providers for Contact Form State
final contactFormNameProvider = StateProvider.autoDispose<String>((ref) => '');
final contactFormContactProvider = StateProvider.autoDispose<String>((ref) => ''); // Email or Phone
final contactFormMessageProvider = StateProvider.autoDispose<String>((ref) => '');
final contactFormLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);


class ContactUsScreen extends ConsumerWidget { // Change to ConsumerWidget
  const ContactUsScreen({super.key});

  // --- URL Launcher Helper (Keep commented if not used) ---
  // Future<void> _launchUrl(String urlString) async { ... }

  // --- Form Submission Handler ---
   void handleSendMessage(BuildContext context, WidgetRef ref) {
      // Use a local key if needed, or access providers directly if validation is simple
      final name = ref.read(contactFormNameProvider);
      final contact = ref.read(contactFormContactProvider);
      final message = ref.read(contactFormMessageProvider);
      final formKey = GlobalKey<FormState>(); // Could be moved outside build if needed persistently

      // Basic manual validation (replace with Form widget if complex)
      if (name.isEmpty || contact.isEmpty || message.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الرجاء ملء جميع حقول نموذج الرسالة'), backgroundColor: AppColors.accent),
          );
          return;
      }

      ref.read(contactFormLoadingProvider.notifier).state = true;

      // TODO: Implement API call to send contact message
      print('Sending Contact Message:');
      print('Name: $name');
      print('Contact: $contact');
      print('Message: $message');

      // Simulate API call
      Future.delayed(const Duration(seconds: 2)).then((_) {
        ref.read(contactFormLoadingProvider.notifier).state = false;
        bool success = true; // Placeholder
        if (success) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إرسال رسالتك بنجاح.'), backgroundColor: Colors.green),
          );
           // Optionally clear the form fields
           ref.read(contactFormNameProvider.notifier).state = '';
           ref.read(contactFormContactProvider.notifier).state = '';
           ref.read(contactFormMessageProvider.notifier).state = '';
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('حدث خطأ أثناء إرسال الرسالة.'), backgroundColor: AppColors.accent),
           );
        }
      }).catchError((e) {
         ref.read(contactFormLoadingProvider.notifier).state = false;
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: $e'), backgroundColor: AppColors.accent),
          );
      });
   }


  @override
  Widget build(BuildContext context, WidgetRef ref) { // Add WidgetRef
    final textTheme = Theme.of(context).textTheme;
    final double verticalSpacing = 20.0;
    final isLoading = ref.watch(contactFormLoadingProvider); // Watch loading state

    // Text Controllers for the form
    final nameController = TextEditingController(text: ref.watch(contactFormNameProvider));
    nameController.selection = TextSelection.fromPosition(TextPosition(offset: nameController.text.length));
    final contactController = TextEditingController(text: ref.watch(contactFormContactProvider));
    contactController.selection = TextSelection.fromPosition(TextPosition(offset: contactController.text.length));
    final messageController = TextEditingController(text: ref.watch(contactFormMessageProvider));
    messageController.selection = TextSelection.fromPosition(TextPosition(offset: messageController.text.length));

    return Directionality(
       textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تواصل معنا'),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نسعد بتواصلكم!',
                 style: textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
               Text(
                'يمكنكم التواصل معنا عبر القنوات التالية أو بإرسال رسالة مباشرة من النموذج أدناه.',
                style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: verticalSpacing),

              // --- Contact Methods (Existing) ---
              _buildContactTile(context, Icons.phone_outlined, 'الهاتف', '+966 12 345 6789', () {/* _launchUrl('tel:...') */}),
              _buildContactTile(context, Icons.support_agent_outlined, 'الدعم الفني / واتساب', '+966 55 555 1234', () {/* _launchUrl('https://wa.me/...') */}),
              _buildContactTile(context, Icons.email_outlined, 'البريد الإلكتروني', 'info@zaindev.com', () {/* _launchUrl('mailto:...') */}),
              _buildContactTile(context, Icons.location_on_outlined, 'العنوان', 'شارع الملك فهد، الرياض...', null), // No action needed usually

              const Divider(height: 32, thickness: 1),

              // --- Contact Form Section ---
               Text(
                'أو أرسل رسالة مباشرة',
                 style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              // Form Fields
               TextField( // Using TextField directly for simplicity here, use TextFormField inside Form for validation
                controller: nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
                onChanged: (value) => ref.read(contactFormNameProvider.notifier).state = value,
              ),
              const SizedBox(height: 12),
               TextField(
                controller: contactController,
                 textDirection: TextDirection.ltr,
                 textAlign: TextAlign.right,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني أو الهاتف'),
                onChanged: (value) => ref.read(contactFormContactProvider.notifier).state = value,
              ),
               const SizedBox(height: 12),
               TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'رسالتك', alignLabelWithHint: true),
                onChanged: (value) => ref.read(contactFormMessageProvider.notifier).state = value,
              ),
              const SizedBox(height: 20),
              // Send Button
              ElevatedButton(
                  onPressed: isLoading ? null : () => handleSendMessage(context, ref),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)), // Full width
                  child: isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('إرسال الرسالة'),
               ),

              const Divider(height: 32, thickness: 1),

               // --- Redesigned "Follow Us" Section ---
               Text(
                'تابعنا على',
                 style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute boxes
                children: [
                  // Replace Icons.facebook etc. with actual brand icons if available (e.g., FontAwesome or SVG)
                   _buildSocialMediaBox(
                      context,
                      icon: Icons.facebook, // Placeholder
                      label: 'فيسبوك',
                      onTap: () { /* _launchUrl('https://facebook.com/...') */ }
                    ),
                    _buildSocialMediaBox(
                      context,
                       icon: Icons.camera_alt_outlined, // Placeholder for Instagram
                      label: 'انستجرام',
                      onTap: () { /* _launchUrl('https://instagram.com/...') */ }
                    ),
                    _buildSocialMediaBox(
                      context,
                       icon: Icons.chat_bubble_outline, // Placeholder for Twitter/X
                      label: 'تويتر',
                      onTap: () { /* _launchUrl('https://twitter.com/...') */ }
                    ),
                   // Add more social platforms (LinkedIn, Snapchat, etc.)
                ],
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

   // --- Helper Widgets (Keep or move to a shared file) ---
   Widget _buildContactTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback? onTap) {
    // ... (same as before) ...
     return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 28),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          textDirection: TextDirection.ltr, // Ensure LTR for numbers/emails
          textAlign: TextAlign.right, // Align LTR text to the right in RTL context
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      onTap: onTap,
    );
   }

   // --- New Helper for Social Media Boxes ---
   Widget _buildSocialMediaBox(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
      final textTheme = Theme.of(context).textTheme;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.0), // Low radius for tap effect
        child: Container(
          width: 85, // Adjust width as needed
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05), // Light background
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: AppColors.divider.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary, size: 30),
              const SizedBox(height: 6),
              Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.primary),
                  textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
   }
}
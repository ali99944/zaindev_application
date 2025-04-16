import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

// Providers for Consultation Form State
final consultationNameProvider = StateProvider.autoDispose<String>((ref) => '');
final consultationContactProvider = StateProvider.autoDispose<String>((ref) => ''); // Email or Phone
final consultationSubjectProvider = StateProvider.autoDispose<String>((ref) => '');
final consultationDescriptionProvider = StateProvider.autoDispose<String>((ref) => '');
final consultationLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

class RequestConsultationScreen extends ConsumerStatefulWidget {
  final String? selectedPackage; // Receive selected package name

  const RequestConsultationScreen({super.key, this.selectedPackage});

  @override
  ConsumerState<RequestConsultationScreen> createState() => _RequestConsultationScreenState();
}

class _RequestConsultationScreenState extends ConsumerState<RequestConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectController;

  @override
  void initState() {
    super.initState();
    // Initialize subject controller, potentially with the passed package name
    final initialSubject = ref.read(consultationSubjectProvider);
    _subjectController = TextEditingController(text: widget.selectedPackage ?? initialSubject);
    // Update provider if initialized with package name
    if (widget.selectedPackage != null && initialSubject.isEmpty) {
       Future.microtask(() => ref.read(consultationSubjectProvider.notifier).state = widget.selectedPackage!);
    }
  }

   @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  void handleSendRequest() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      ref.read(consultationLoadingProvider.notifier).state = true;

      final name = ref.read(consultationNameProvider);
      final contact = ref.read(consultationContactProvider);
      final subject = ref.read(consultationSubjectProvider); // Use provider state
      final description = ref.read(consultationDescriptionProvider);

      // TODO: Implement API call to send consultation request
      print('Sending Consultation Request:');
      print('Name: $name');
      print('Contact: $contact');
      print('Subject: $subject');
      print('Description: $description');

      // Simulate API call
      Future.delayed(const Duration(seconds: 2)).then((_) {
        ref.read(consultationLoadingProvider.notifier).state = false;
        // TODO: Handle success/error from API
        bool success = true; // Placeholder
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('تم إرسال طلب الاستشارة بنجاح. سنتواصل معك قريباً.'),
                backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(); // Go back after successful submission
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('حدث خطأ أثناء إرسال الطلب. يرجى المحاولة مرة أخرى.'),
                backgroundColor: AppColors.accent),
          );
        }
      }).catchError((error) {
         ref.read(consultationLoadingProvider.notifier).state = false;
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: $error'), backgroundColor: AppColors.accent),
          );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLoading = ref.watch(consultationLoadingProvider);

    // Watch providers for controllers (if not using listeners)
    final nameController = TextEditingController(text: ref.watch(consultationNameProvider));
    nameController.selection = TextSelection.fromPosition(TextPosition(offset: nameController.text.length)); // Keep cursor at end
    final contactController = TextEditingController(text: ref.watch(consultationContactProvider));
    contactController.selection = TextSelection.fromPosition(TextPosition(offset: contactController.text.length));
    _subjectController.text = ref.watch(consultationSubjectProvider); // Keep subject controller updated
    _subjectController.selection = TextSelection.fromPosition(TextPosition(offset: _subjectController.text.length));
    final descriptionController = TextEditingController(text: ref.watch(consultationDescriptionProvider));
    descriptionController.selection = TextSelection.fromPosition(TextPosition(offset: descriptionController.text.length));


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلب استشارة'),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'املأ النموذج التالي لطلب استشارة فنية وسيقوم فريقنا بالتواصل معك.',
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person_outline)),
                  validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال الاسم' : null,
                  onChanged: (value) => ref.read(consultationNameProvider.notifier).state = value,
                ),
                const SizedBox(height: 16),

                // Contact Field (Email or Phone)
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.text, // Allow both email/phone
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني أو رقم الهاتف للتواصل',
                    prefixIcon: Icon(Icons.contact_mail_outlined),
                  ),
                   validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال وسيلة تواصل (بريد أو هاتف)';
                      }
                      return null;
                    },
                     onChanged: (value) => ref.read(consultationContactProvider.notifier).state = value,
                ),
                const SizedBox(height: 16),

                // Subject Field (Pre-filled if package selected)
                 TextFormField(
                  controller: _subjectController, // Use the stateful controller
                  decoration: const InputDecoration(
                    labelText: 'الموضوع / الخدمة المطلوبة',
                    prefixIcon: Icon(Icons.subject_outlined),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال الموضوع' : null,
                  onChanged: (value) => ref.read(consultationSubjectProvider.notifier).state = value,
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'وصف موجز للاستشارة المطلوبة',
                    prefixIcon: Icon(Icons.description_outlined),
                    alignLabelWithHint: true, // Align label to top for multiline
                  ),
                   validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال وصف للاستشارة' : null,
                    onChanged: (value) => ref.read(consultationDescriptionProvider.notifier).state = value,
                ),
                const SizedBox(height: 32),

                // Send Button
                 ElevatedButton(
                     onPressed: isLoading ? null : handleSendRequest,
                     style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                     child: isLoading
                         ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                         : const Text('إرسال طلب الاستشارة'),
                   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

// Providers for Service Request Form
final requestServiceNameProvider = StateProvider.autoDispose<String>((ref) => ''); // Pre-fill later
final requestNameProvider = StateProvider.autoDispose<String>((ref) => ''); // Pre-fill if logged in
final requestContactProvider = StateProvider.autoDispose<String>((ref) => ''); // Pre-fill if logged in
final requestAddressProvider = StateProvider.autoDispose<String>((ref) => '');
final requestPreferredDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final requestPreferredTimeProvider = StateProvider.autoDispose<TimeOfDay?>((ref) => null);
final requestNotesProvider = StateProvider.autoDispose<String>((ref) => '');
final requestLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);


class RequestServiceScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const RequestServiceScreen({super.key, required this.serviceId});

  @override
  ConsumerState<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends ConsumerState<RequestServiceScreen> {
   final _formKey = GlobalKey<FormState>();

   @override
  void initState() {
    super.initState();
    // TODO: Fetch service name based on widget.serviceId and pre-fill provider
     // TODO: Fetch logged-in user name/contact and pre-fill providers if available
    // Example (replace with actual fetching):
    // Future.microtask(() {
    //    ref.read(requestServiceNameProvider.notifier).state = "اسم الخدمة لـ ${widget.serviceId}";
    //    final user = ref.read(userProfileProvider); // Assuming user provider exists
    //    final isLoggedIn = ref.read(authStateProvider);
    //    if(isLoggedIn) {
    //      ref.read(requestNameProvider.notifier).state = user['name'] ?? '';
    //      ref.read(requestContactProvider.notifier).state = user['phone'] ?? user['email'] ?? '';
    //    }
    // });
  }

   Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: ref.read(requestPreferredDateProvider) ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 90)), // Allow booking 3 months ahead
    );
    if (picked != null && picked != ref.read(requestPreferredDateProvider)) {
      ref.read(requestPreferredDateProvider.notifier).state = picked;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: ref.read(requestPreferredTimeProvider) ?? TimeOfDay.now(),
      );
       if (picked != null && picked != ref.read(requestPreferredTimeProvider)) {
        ref.read(requestPreferredTimeProvider.notifier).state = picked;
      }
  }

   void handleSubmitRequest() {
      if (_formKey.currentState?.validate() ?? false) {
         _formKey.currentState?.save();
         ref.read(requestLoadingProvider.notifier).state = true;

         final requestData = {
            'serviceId': widget.serviceId,
            'serviceName': ref.read(requestServiceNameProvider),
            'customerName': ref.read(requestNameProvider),
            'customerContact': ref.read(requestContactProvider),
            'address': ref.read(requestAddressProvider),
            'preferredDate': ref.read(requestPreferredDateProvider)?.toIso8601String(),
            'preferredTime': ref.read(requestPreferredTimeProvider)?.format(context), // Format TimeOfDay
            'notes': ref.read(requestNotesProvider),
         };

         // TODO: Implement API call to submit service request
         print('Submitting Service Request: $requestData');
         Future.delayed(const Duration(seconds: 2)).then((_) {
             ref.read(requestLoadingProvider.notifier).state = false;
             bool success = true; // Placeholder
             String bookingCode = "ZN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}"; // Dummy code

             if (success) {
                 Navigator.pushReplacementNamed( // Use replacement to remove form from stack
                    context,
                    AppRoutes.bookingSuccess,
                    arguments: {
                        'bookingCode': bookingCode,
                        'serviceName': requestData['serviceName'] ?? 'الخدمة المطلوبة'
                    }
                 );
             } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('فشل إرسال الطلب. حاول مرة أخرى.'), backgroundColor: AppColors.accent),
                );
             }
         });
      }
   }

  @override
  Widget build(BuildContext context) {
     final textTheme = Theme.of(context).textTheme;
     final isLoading = ref.watch(requestLoadingProvider);
     final serviceName = ref.watch(requestServiceNameProvider); // Get service name
     final selectedDate = ref.watch(requestPreferredDateProvider);
     final selectedTime = ref.watch(requestPreferredTimeProvider);

     // Controllers (manage cursor position)
     final nameController = TextEditingController(text: ref.watch(requestNameProvider));
     nameController.selection = TextSelection.fromPosition(TextPosition(offset: nameController.text.length));
     final contactController = TextEditingController(text: ref.watch(requestContactProvider));
     contactController.selection = TextSelection.fromPosition(TextPosition(offset: contactController.text.length));
     final addressController = TextEditingController(text: ref.watch(requestAddressProvider));
     addressController.selection = TextSelection.fromPosition(TextPosition(offset: addressController.text.length));
     final notesController = TextEditingController(text: ref.watch(requestNotesProvider));
     notesController.selection = TextSelection.fromPosition(TextPosition(offset: notesController.text.length));


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
           title: Text('طلب خدمة: ${serviceName.isNotEmpty ? serviceName : '...'}'),
           backgroundColor: AppColors.primary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
             key: _formKey,
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text('يرجى ملء التفاصيل التالية لإكمال طلب الخدمة', style: textTheme.bodyLarge),
                   const SizedBox(height: 24),

                   // --- Service Name (Display Only) ---
                    if (serviceName.isNotEmpty) ...[
                        InputDecorator(
                          decoration: const InputDecoration(labelText: 'الخدمة المطلوبة', border: InputBorder.none, contentPadding: EdgeInsets.zero),
                          child: Text(serviceName, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                         const SizedBox(height: 16),
                    ],

                   // --- Contact Info ---
                    TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                        validator: (v) => (v == null || v.isEmpty) ? 'الاسم مطلوب' : null,
                        onChanged: (v) => ref.read(requestNameProvider.notifier).state = v,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                       controller: contactController,
                       keyboardType: TextInputType.text,
                       textDirection: TextDirection.ltr,
                       textAlign: TextAlign.right,
                       decoration: const InputDecoration(labelText: 'رقم الهاتف أو البريد الإلكتروني'),
                       validator: (v) => (v == null || v.isEmpty) ? 'وسيلة التواصل مطلوبة' : null,
                        onChanged: (v) => ref.read(requestContactProvider.notifier).state = v,
                    ),
                    const SizedBox(height: 16),

                    // --- Address ---
                    TextFormField(
                       controller: addressController,
                       maxLines: 2,
                       decoration: const InputDecoration(labelText: 'العنوان بالتفصيل', hintText: 'مثال: مدينة الرياض، حي العليا، شارع التحلية، مبنى 12'),
                       validator: (v) => (v == null || v.isEmpty) ? 'العنوان مطلوب' : null,
                        onChanged: (v) => ref.read(requestAddressProvider.notifier).state = v,
                    ),
                     // TODO: Consider adding a map picker button here

                    const SizedBox(height: 16),

                    // --- Preferred Date & Time ---
                    Row(
                       children: [
                          Expanded(
                             child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'التاريخ المفضل (اختياري)'),
                                child: TextButton.icon(
                                   icon: const Icon(Icons.calendar_today_outlined, size: 20),
                                   label: Text(selectedDate == null ? 'اختر تاريخ' : '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}'),
                                   onPressed: () => _selectDate(context),
                                ),
                             ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                             child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'الوقت المفضل (اختياري)'),
                                child: TextButton.icon(
                                    icon: const Icon(Icons.access_time_outlined, size: 20),
                                    label: Text(selectedTime == null ? 'اختر وقت' : selectedTime.format(context)),
                                    onPressed: () => _selectTime(context),
                                ),
                             ),
                          ),
                       ],
                    ),
                     const SizedBox(height: 16),

                    // --- Notes ---
                     TextFormField(
                       controller: notesController,
                       maxLines: 3,
                       decoration: const InputDecoration(labelText: 'ملاحظات إضافية (اختياري)', alignLabelWithHint: true),
                        onChanged: (v) => ref.read(requestNotesProvider.notifier).state = v,
                    ),
                    const SizedBox(height: 32),

                    // --- Submit Button ---
                     ElevatedButton(
                         onPressed: isLoading ? null : handleSubmitRequest,
                         style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                         child: isLoading
                             ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                             : const Text('تأكيد وإرسال الطلب'),
                       ),
                ],
             ),
          ),
        ),
      ),
    );
  }
}
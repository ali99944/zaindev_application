import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String bookingCode;
  final String serviceName;

  const BookingSuccessScreen({
    super.key,
    required this.bookingCode,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // No AppBar needed usually for success screens
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Success Icon ---
              Icon(Icons.check_circle_outline_rounded, size: 100, color: Colors.green[600]),
              const SizedBox(height: 24),

              // --- Success Message ---
              Text(
                'تم استلام طلبك بنجاح!',
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'سيقوم فريقنا بمراجعة طلب خدمة "$serviceName" والتواصل معك قريباً للتأكيد.',
                style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // --- Booking Code Display ---
              Container(
                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                 decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2))
                 ),
                 child: Column(
                    children: [
                       Text('رقم مرجع الطلب الخاص بك هو:', style: textTheme.bodyMedium),
                       const SizedBox(height: 4),
                       SelectableText( // Allow user to copy the code
                         bookingCode,
                         style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.5),
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: 4),
                       Text('احتفظ بهذا الرقم للمتابعة.', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ],
                 ),
              ),
              const SizedBox(height: 40),

              // --- Navigation Buttons ---
              ElevatedButton.icon(
                 icon: const Icon(Icons.track_changes_outlined),
                 label: const Text('تتبع حالة الطلب'),
                 onPressed: () {
                    // TODO: Navigate to Track Order screen, potentially passing the booking code
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Track Order - Coming Soon')));
                    // Navigator.pushNamed(context, AppRoutes.trackOrder, arguments: bookingCode);
                 },
                 style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.textOnSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                 ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon( // Use outlined for secondary action
                 icon: const Icon(Icons.home_outlined),
                 label: const Text('العودة إلى الرئيسية'),
                 onPressed: () {
                   Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeNavigator, (route) => false);
                 },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                 ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
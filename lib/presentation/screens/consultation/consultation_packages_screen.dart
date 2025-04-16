import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

// Simple Model for Consultation Package
class ConsultationPackage {
  final String id;
  final String name;
  final String description;
  final String? price; // Optional price display
  final List<String> features;

  ConsultationPackage({
    required this.id,
    required this.name,
    required this.description,
    this.price,
    required this.features,
  });
}

class ConsultationPackagesScreen extends StatelessWidget {
  const ConsultationPackagesScreen({super.key});

  // Dummy Data (Replace with API call)
  static final List<ConsultationPackage> _packagesData = [
    ConsultationPackage(
      id: 'basic',
      name: 'استشارة سريعة (15 دقيقة)',
      description: 'للاستفسارات السريعة والأسئلة المباشرة حول خدمة معينة أو مشكلة بسيطة.',
      price: '50 ريال',
      features: ['مكالمة هاتفية/فيديو', 'مناسبة لأسئلة محددة', 'إجابات مباشرة'],
    ),
    ConsultationPackage(
      id: 'standard',
      name: 'استشارة قياسية (30 دقيقة)',
      description: 'لمناقشة متطلبات مشروع صغير أو مشكلة فنية تحتاج بعض التفصيل.',
      price: '150 ريال',
      features: ['مكالمة هاتفية/فيديو', 'تحليل مبدئي للمشكلة', 'توصيات أولية', 'متابعة عبر البريد'],
    ),
    ConsultationPackage(
      id: 'premium',
      name: 'استشارة شاملة (60 دقيقة)',
      description: 'للمشاريع الكبيرة، المشاكل المعقدة، أو الحاجة لتحليل معمق وخطط عمل.',
      price: '300 ريال',
      features: ['مكالمة هاتفية/فيديو مطولة', 'تحليل معمق للمتطلبات', 'خطة عمل مقترحة', 'دعم متابعة مخصص'],
    ),
     ConsultationPackage(
      id: 'custom',
      name: 'استشارة مخصصة',
      description: 'إذا كانت متطلباتك لا تتناسب مع الباقات المذكورة، اطلب استشارة مخصصة.',
      features: ['تحديد المدة حسب الحاجة', 'تحديد السعر بعد المناقشة', 'مرونة في المحتوى'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
     final textTheme = Theme.of(context).textTheme;

    return Directionality(
       textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('باقات الاستشارات'),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _packagesData.length,
          itemBuilder: (context, index) {
            return _buildPackageBox(context, _packagesData[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPackageBox(BuildContext context, ConsultationPackage package) {
     final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
         color: AppColors.background,
         borderRadius: BorderRadius.circular(4.0), // Low radius
         border: Border.all(color: AppColors.divider.withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.name,
            style: textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          if (package.price != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                 package.price!,
                 style: textTheme.titleMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            package.description,
             style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 12),
           Text('المميزات:', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
           const SizedBox(height: 4),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: package.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0, right: 8.0), // Indent features slightly
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature, style: textTheme.bodyMedium)),
                  ],
                ),
              )).toList(),
           ),
           const SizedBox(height: 16),
           Center( // Center the button
             child: ElevatedButton(
               onPressed: () {
                  // Navigate to request form, passing package name
                  Navigator.pushNamed(
                    context,
                    AppRoutes.requestConsultation,
                    arguments: package.name, // Pass package name as argument
                  );
               },
               style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.secondary,
                   foregroundColor: AppColors.textOnSecondary,
                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
               ),
               child: const Text('طلب هذه الباقة'),
             ),
           ),
        ],
      ),
    );
  }
}
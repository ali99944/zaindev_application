import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  // Dummy FAQ Data (Replace with actual data source)
  static const List<Map<String, String>> _faqData = [
    {
      'question': 'كيف يمكنني طلب خدمة؟',
      'answer': 'يمكنك طلب خدمة بسهولة من خلال قسم "الخدمات" في التطبيق، اختر الفئة والخدمة المطلوبة، ثم املأ تفاصيل الطلب.'
    },
    {
      'question': 'ما هي طرق الدفع المتاحة؟',
      'answer': 'نوفر حاليًا طرق دفع متعددة تشمل [اذكر طرق الدفع مثل: مدى، فيزا، ماستركارد، Apple Pay]. يمكنك اختيار الطريقة المناسبة عند إتمام الطلب.'
    },
    {
      'question': 'كيف يمكنني تتبع طلبي؟',
      'answer': 'إذا قمت بتسجيل الدخول، يمكنك تتبع حالة طلباتك من قسم "الحجوزات" أو "المزيد". للزوار، يمكن استخدام خيار تتبع الطلب المتاح في الشاشة الرئيسية أو صفحة تسجيل الدخول باستخدام رقم الطلب.'
    },
     {
      'question': 'كيف أحصل على استشارة فنية؟',
      'answer': 'يمكنك طلب استشارة عبر الضغط على زر الدعم العائم واختيار "احصل على استشارة"، أو زيارة قسم الاستشارات وحجز موعد أو باقة.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الدعم والمساعدة'),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تحتاج مساعدة؟',
                      style: textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'نحن هنا لمساعدتك. تصفح الأسئلة الشائعة أو تواصل معنا مباشرة.',
                      style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              // --- Quick Actions ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('إجراءات سريعة', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ),
              _buildQuickAction(
                  context, Icons.support_agent_outlined, 'طلب استشارة فنية', AppRoutes.requestConsultation),
              _buildQuickAction(
                  context, Icons.add_circle_outline, 'طلب خدمة جديدة', AppRoutes.servicesCategories), // Navigate to services tab/page
              _buildQuickAction(
                  context, Icons.contact_phone_outlined, 'تواصل معنا مباشرة', AppRoutes.contactUs),

              const Divider(height: 32, thickness: 1, indent: 16, endIndent: 16),

              // --- FAQs Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('الأسئلة الشائعة', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                 shrinkWrap: true, // Important inside SingleChildScrollView
                 physics: const NeverScrollableScrollPhysics(), // Disable nested scrolling
                 itemCount: _faqData.length,
                 itemBuilder: (context, index) {
                   final faq = _faqData[index];
                   return ExpansionTile(
                      title: Text(faq['question']!, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                      childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(bottom: 16),
                      iconColor: AppColors.primary,
                      collapsedIconColor: AppColors.textSecondary,
                      children: [
                        Text(faq['answer']!, style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary, height: 1.5)),
                      ],
                   );
                 },
              ),
              const SizedBox(height: 30), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Quick Action tiles
  Widget _buildQuickAction(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 26),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary.withOpacity(0.7)),
      onTap: () => Navigator.pushNamed(context, route),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}
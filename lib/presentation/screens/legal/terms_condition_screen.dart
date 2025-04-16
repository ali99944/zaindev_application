import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

    // Reusing helper widgets from Privacy Policy Screen for consistency
   Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0), // Add top padding too
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

    Widget _buildParagraph(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6, color: AppColors.textSecondary),
    );
  }

  @override
  Widget build(BuildContext context) {
     final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الشروط والأحكام'),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'شروط وأحكام استخدام تطبيق زين التنموية',
                 style: textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'آخر تحديث: [أدخل تاريخ آخر تحديث هنا]',
                style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),

              _buildSectionTitle(context, '1. قبول الشروط'),
              _buildParagraph(context, 'باستخدامك لتطبيق زين التنموية ("التطبيق")، فإنك توافق على الالتزام بهذه الشروط والأحكام ("الشروط"). إذا كنت لا توافق على هذه الشروط، يرجى عدم استخدام التطبيق.'),

              _buildSectionTitle(context, '2. استخدام الخدمة'),
              _buildParagraph(context, 'يسمح لك باستخدام التطبيق للتعرف على خدمات مؤسسة زين التنموية ("المؤسسة")، طلب الخدمات، حجز المواعيد، وشراء المنتجات المتاحة (إن وجدت). يجب استخدام التطبيق لأغراض قانونية فقط وبطريقة لا تنتهك حقوق الآخرين.'),

               // Add section for User Accounts if login is implemented
              _buildSectionTitle(context, '3. الحسابات (إن وجدت)'),
               _buildParagraph(context, 'قد يتطلب الوصول إلى بعض الميزات إنشاء حساب. أنت مسؤول عن الحفاظ على سرية معلومات حسابك وعن جميع الأنشطة التي تحدث تحت حسابك. يجب عليك إخطارنا فورًا بأي استخدام غير مصرح به لحسابك.'),

              _buildSectionTitle(context, '4. المحتوى والملكية الفكرية'),
               _buildParagraph(context, 'جميع المحتويات المتوفرة على التطبيق، بما في ذلك النصوص والرسومات والشعارات والصور والبرمجيات، هي ملك للمؤسسة أو مرخصة لها ومحمية بموجب قوانين حقوق النشر والعلامات التجارية. لا يجوز لك نسخ أو تعديل أو توزيع أو بيع أي جزء من محتوى التطبيق دون إذن كتابي مسبق.'),

              _buildSectionTitle(context, '5. طلبات الخدمة والدفع'),
               _buildParagraph(context, 'عند طلب خدمة أو منتج، فإنك توافق على تقديم معلومات دقيقة وكاملة. تحتفظ المؤسسة بالحق في رفض أو إلغاء أي طلب لأي سبب. تخضع عمليات الدفع للشروط والأحكام الخاصة بمزودي خدمة الدفع المعتمدين.'),

               _buildSectionTitle(context, '6. إخلاء المسؤولية'),
              _buildParagraph(context, 'يتم توفير التطبيق "كما هو" دون أي ضمانات صريحة أو ضمنية. لا تضمن المؤسسة أن التطبيق سيكون خاليًا من الأخطاء أو الانقطاع. استخدامك للتطبيق على مسؤوليتك الخاصة.'),

              _buildSectionTitle(context, '7. تحديد المسؤولية'),
               _buildParagraph(context, 'لن تكون المؤسسة مسؤولة عن أي أضرار مباشرة أو غير مباشرة أو عرضية أو تبعية تنشأ عن استخدامك أو عدم قدرتك على استخدام التطبيق.'),

               _buildSectionTitle(context, '8. الروابط الخارجية'),
                _buildParagraph(context, 'قد يحتوي التطبيق على روابط لمواقع أو خدمات تابعة لجهات خارجية. لا نتحمل أي مسؤولية عن محتوى أو ممارسات الخصوصية لهذه المواقع.'),

               _buildSectionTitle(context, '9. القانون الحاكم'),
              _buildParagraph(context, 'تخضع هذه الشروط وتُفسر وفقًا لقوانين المملكة العربية السعودية.'),

               _buildSectionTitle(context, '10. التغييرات على الشروط'),
              _buildParagraph(context, 'نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم نشر النسخة المحدثة على هذه الصفحة. استمرارك في استخدام التطبيق بعد نشر التغييرات يشكل موافقتك عليها.'),

               _buildSectionTitle(context, '11. اتصل بنا'),
               _buildParagraph(context, 'إذا كانت لديك أي أسئلة حول هذه الشروط والأحكام، يرجى التواصل معنا عبر قنوات الاتصال المتاحة.'),
            ],
          ),
        ),
      ),
    );
  }
}
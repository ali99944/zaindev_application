import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double verticalSpacing = 16.0;

    return Directionality(
       textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سياسة الخصوصية'),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سياسة الخصوصية لتطبيق زين التنموية',
                style: textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'آخر تحديث: [أدخل تاريخ آخر تحديث هنا]', // e.g., 25 أكتوبر 2023
                style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: verticalSpacing),

              _buildSectionTitle(context, '1. مقدمة'),
              _buildParagraph(context, 'نحن في مؤسسة زين التنموية ("المؤسسة"، "نحن"، "لنا") نلتزم بحماية خصوصية مستخدمي تطبيقنا ("التطبيق"). توضح سياسة الخصوصية هذه كيف نجمع، نستخدم، ونحمي معلوماتك الشخصية عند استخدامك للتطبيق.'),
              SizedBox(height: verticalSpacing),

              _buildSectionTitle(context, '2. المعلومات التي نجمعها'),
               _buildParagraph(context, 'قد نجمع أنواعًا مختلفة من المعلومات، بما في ذلك:\n'
                   '- معلومات شخصية تقدمها طواعية (مثل الاسم، رقم الهاتف، البريد الإلكتروني عند التسجيل أو طلب خدمة).\n'
                   '- معلومات الاستخدام (مثل الصفحات التي تزورها، الميزات المستخدمة، سجلات الأعطال).\n'
                   '- معلومات الموقع (إذا منحت الإذن، لتحديد مواقع طلبات الخدمة).\n'
                   '- معلومات الجهاز (مثل نوع الجهاز، نظام التشغيل، معرفات الجهاز الفريدة).'),
               SizedBox(height: verticalSpacing),

               _buildSectionTitle(context, '3. كيف نستخدم معلوماتك'),
               _buildParagraph(context, 'نستخدم المعلومات التي نجمعها للأغراض التالية:\n'
                   '- توفير وصيانة وتحسين خدمات التطبيق.\n'
                   '- معالجة طلباتك وحجوزاتك ومعاملاتك.\n'
                   '- التواصل معك بشأن حسابك أو خدماتنا.\n'
                   '- تخصيص تجربتك وتقديم محتوى وعروض ذات صلة.\n'
                   '- تحليل استخدام التطبيق لأغراض البحث والتطوير.\n'
                   '- ضمان أمن التطبيق ومنع الاحتيال.'),
              SizedBox(height: verticalSpacing),

              _buildSectionTitle(context, '4. مشاركة المعلومات'),
               _buildParagraph(context, 'قد نشارك معلوماتك مع أطراف ثالثة في ظروف محدودة، مثل:\n'
                   '- مزودي الخدمة المعتمدين لدينا لتنفيذ الطلبات.\n'
                   '- شركاء تحليلات البيانات لمساعدتنا في فهم استخدام التطبيق.\n'
                   '- السلطات القانونية إذا طُلب منا ذلك بموجب القانون.'),
              SizedBox(height: verticalSpacing),

               _buildSectionTitle(context, '5. أمن البيانات'),
               _buildParagraph(context, 'نتخذ تدابير أمنية معقولة لحماية معلوماتك من الوصول غير المصرح به أو التغيير أو الكشف أو الإتلاف. ومع ذلك، لا توجد طريقة نقل عبر الإنترنت أو تخزين إلكتروني آمنة بنسبة 100%.'),
              SizedBox(height: verticalSpacing),

               _buildSectionTitle(context, '6. خياراتك'),
              _buildParagraph(context, 'يمكنك الوصول إلى معلومات حسابك وتحديثها من خلال إعدادات التطبيق. يمكنك أيضًا إلغاء الاشتراك في الاتصالات التسويقية وإدارة أذونات الموقع.'),
               SizedBox(height: verticalSpacing),

               _buildSectionTitle(context, '7. التغييرات على هذه السياسة'),
              _buildParagraph(context, 'قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. سنخطرك بأي تغييرات جوهرية عن طريق نشر السياسة الجديدة على هذه الصفحة أو من خلال إشعار داخل التطبيق.'),
               SizedBox(height: verticalSpacing),

               _buildSectionTitle(context, '8. اتصل بنا'),
               _buildParagraph(context, 'إذا كانت لديك أي أسئلة حول سياسة الخصوصية هذه، يرجى التواصل معنا عبر قنوات الاتصال المتاحة في قسم "تواصل معنا".'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
}
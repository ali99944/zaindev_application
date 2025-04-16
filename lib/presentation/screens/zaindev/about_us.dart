import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double verticalSpacing = 16.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('عن زين التنموية'),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  AppAssets.logo,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.business_sharp, size: 80, color: AppColors.primary),
                ),
              ),
              SizedBox(height: verticalSpacing * 1.5),
              Text(
                'من نحن؟',
                style: textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'زين التنموية هي مؤسسة رائدة متخصصة في تقديم حلول متكاملة في مجالات [اذكر المجالات الرئيسية مثل: التكييف، الصيانة، المقاولات، الاستشارات الفنية]. نسعى لتقديم خدمات عالية الجودة تلبي احتياجات عملائنا وتفوق توقعاتهم.',
                style: textTheme.bodyLarge?.copyWith(height: 1.5), // Add line height for readability
              ),
              SizedBox(height: verticalSpacing),
              Text(
                'رؤيتنا',
                style: textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'أن نكون الخيار الأول والموثوق لعملائنا في جميع الخدمات التي نقدمها في [اذكر المنطقة/المملكة].',
                 style: textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              SizedBox(height: verticalSpacing),
              Text(
                'رسالتنا',
                 style: textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'توفير حلول مبتكرة وفعالة من حيث التكلفة، مع الالتزام بأعلى معايير الجودة والسلامة، وبناء علاقات قوية ومستدامة مع عملائنا وشركائنا.',
                 style: textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
               SizedBox(height: verticalSpacing),
               Text(
                'قيمنا',
                 style: textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildValueItem(context, Icons.check_circle_outline, 'الجودة والاتقان'),
              _buildValueItem(context, Icons.groups_outlined, 'العميل أولاً'),
              _buildValueItem(context, Icons.security_outlined, 'الموثوقية والأمانة'),
              _buildValueItem(context, Icons.lightbulb_outline, 'الابتكار والتطوير'),
               _buildValueItem(context, Icons.handshake_outlined, 'الاحترافية والالتزام'),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20), // Use secondary color for values?
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
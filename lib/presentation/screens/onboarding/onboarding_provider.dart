import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_assets.dart';
import 'widgets/onboarding_item.dart';

// Provider for the current page index
final onboardingPageIndexProvider = StateProvider<int>((ref) => 0);

// Provider for the onboarding content
final onboardingItemsProvider = Provider<List<OnboardingItem>>((ref) {
  // TODO: Replace with actual localized strings from translation files
  return [
    OnboardingItem(
      imagePath: AppAssets.onboarding1,
      title: 'اكتشف زين التنموية', // "Discover Zain Development"
      description: 'تعرف على مؤسستنا ومشاريعنا ومنتجاتنا بسهولة عبر التطبيق.', // "Learn about our foundation, projects, and products easily through the app."
    ),
    OnboardingItem(
      imagePath: AppAssets.onboarding2,
      title: 'خدمات متكاملة', // "Integrated Services"
      description: 'اطلب منتجات مثل المكيفات أو احجز خدمات الدعم والاستشارات.', // "Order products like air conditioners or book support and consulting services."
    ),
    OnboardingItem(
      imagePath: AppAssets.onboarding3,
      title: 'تواصل مباشر', // "Direct Communication"
      description: 'تواصل معنا بسهولة وقدم ملاحظاتك لتجربة أفضل.', // "Contact us easily and provide your feedback for a better experience."
    ),
  ];
});
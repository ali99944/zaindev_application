import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/service_category.dart';

// Re-use dummy data for now
class ServiceInfo {
  final String id;
  final String name;
  final IconData? icon;
  final String? imageUrl; // Add imageUrl

  ServiceInfo({required this.id, required this.name, this.icon, this.imageUrl});
}
final List<ServiceInfo> dummyServiceCategories = [
  ServiceInfo(id: '1', name: 'تركيب مكيفات', icon: Icons.add_box_outlined), // Example icons
  ServiceInfo(id: '2', name: 'صيانة مكيفات', icon: Icons.build_circle_outlined),
  ServiceInfo(id: '3', name: 'تنظيف وغسيل', icon: Icons.cleaning_services_outlined),
  ServiceInfo(id: '4', name: 'قطع غيار', icon: Icons.settings_input_component),
  ServiceInfo(id: '5', name: 'استشارات فنية', icon: Icons.support_agent_outlined),
  ServiceInfo(id: '6', name: 'مشاريع خاصة', icon: Icons.construction_outlined),
  ServiceInfo(id: '7', name: 'تمديد وتأسيس', icon: Icons.handyman_outlined),
  ServiceInfo(id: '8', name: 'عروض وباقات', icon: Icons.local_offer_outlined),
  ServiceInfo(id: '9', name: 'تشغيل وخدمة', icon: Icons.engineering_outlined),
  ServiceInfo(id: '10', name: 'كشف ومراجعة', icon: Icons.search),
  ServiceInfo(id: '11', name: 'صيانة عامة', icon: Icons.settings_applications_outlined)
];

class AllServiceCategoriesScreen extends ConsumerWidget {
  static const String route = "/services-categories";
  const AllServiceCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = dummyServiceCategories;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('جميع فئات الخدمات')
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Adjust number of columns
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.9, // Adjust aspect ratio (width/height)
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ServiceCategoryItem(
              name: category.name,
              icon: category.icon!,
              onTap: () {
                // TODO: Navigate to screen showing services within this specific category
                print('Tapped on category: ${category.name}');
                // Navigator.pushNamed(context, AppRoutes.servicesInCategory, arguments: category.id);
              },
            );
          },
        ),
      ),
    );
  }
}
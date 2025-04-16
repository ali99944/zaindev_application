import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

// Dummy Model for Sub Service (Replace with actual)
class SubService {
  final String id;
  final String name;
  final IconData icon; // Or image path
  final String categoryId;
  final String? estimatedPrice; // Optional

  SubService({
    required this.id,
    required this.name,
    required this.icon,
    required this.categoryId,
    this.estimatedPrice,
  });
}

// Provider to fetch sub-services based on category ID (Replace with API)
final subServicesProvider = FutureProvider.family<List<SubService>, String>((ref, categoryId) async{
  await Future.delayed(Duration(seconds: 4));
  // Dummy Data:
  if (categoryId == 'cat1') { // Example: AC category
      return [
        SubService(id: 'sub1_1', name: 'تركيب مكيف سبليت', icon: Icons.add_box_outlined, categoryId: categoryId, estimatedPrice: '250 ريال'),
        SubService(id: 'sub1_2', name: 'صيانة دورية للمكيف', icon: Icons.build_outlined, categoryId: categoryId, estimatedPrice: '150 ريال'),
        SubService(id: 'sub1_3', name: 'تعبئة فريون', icon: Icons.ac_unit, categoryId: categoryId, estimatedPrice: '180 ريال'),
        SubService(id: 'sub1_4', name: 'تنظيف مكيفات', icon: Icons.cleaning_services_outlined, categoryId: categoryId),
      ];
  }
   if (categoryId == 'cat2') { // Example: Maintenance
      return [
         SubService(id: 'sub2_1', name: 'إصلاح أعطال كهربائية', icon: Icons.electrical_services, categoryId: categoryId),
        SubService(id: 'sub2_2', name: 'أعمال سباكة بسيطة', icon: Icons.water_damage_outlined, categoryId: categoryId),
      ];
   }
  return []; // Default empty list
});


class SubServicesScreen extends ConsumerWidget {
  final String categoryId; // Passed via arguments

  const SubServicesScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subServicesAsyncValue = ref.watch(subServicesProvider(categoryId));
    final categoryName = "خدمات القسم"; // Placeholder Title

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName), // Use actual category name
          backgroundColor: AppColors.primary,
        ),
        body: subServicesAsyncValue.when(
          data: (subServices) {
            if (subServices.isEmpty) {
              return const Center(child: Text('لا توجد خدمات متاحة في هذا القسم حالياً.'));
            }
            // --- Grid Layout ---
            final screenPadding = 12.0;
            final itemSpacing = 8.0;
            return GridView.builder(
              padding: EdgeInsets.all(screenPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: itemSpacing,
                mainAxisSpacing: itemSpacing,
                childAspectRatio: 1.05, // Adjust ratio for potentially more text
              ),
              itemCount: subServices.length,
              itemBuilder: (context, index) {
                return _SubServiceBox(subService: subServices[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('خطأ في تحميل الخدمات: $error')),
        ),
      ),
    );
  }
}

// Reusable widget for the sub-service box
class _SubServiceBox extends StatelessWidget {
  final SubService subService;

  const _SubServiceBox({required this.subService});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // Navigate to sub-service details screen, passing service ID
        Navigator.pushNamed(context, AppRoutes.subServiceDetails, arguments: subService.id);
      },
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: AppColors.divider),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(subService.icon, size: 36.0, color: AppColors.primary),
            const SizedBox(height: 10.0),
            Text(
              subService.name,
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
             if (subService.estimatedPrice != null) ...[
                const SizedBox(height: 4.0),
                Text(
                  subService.estimatedPrice!,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.accent),
                  textAlign: TextAlign.center,
                ),
            ]
          ],
        ),
      ),
    );
  }
}
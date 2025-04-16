import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/icon_mapper.dart';
import '../../../domain/entities/service_category.dart';
import 'service_provider.dart'; // Import the provider

class ServicesCategoriesPage extends ConsumerWidget {
  const ServicesCategoriesPage({super.key});

  Future<void> _refreshCategories(WidgetRef ref) async {
     ref.invalidate(serviceCategoriesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the new FutureProvider
    final categoriesAsyncValue = ref.watch(serviceCategoriesProvider);

    return Scaffold( // Add scaffold if needed (if not part of HomeNavigator)
      body: RefreshIndicator(
        onRefresh: () => _refreshCategories(ref),
        color: AppColors.primary,
        child: categoriesAsyncValue.when(
          data: (categories) {
            if (categories.isEmpty) {
              return const Center(child: Text('لا توجد فئات خدمات متاحة حالياً.'));
            }
            // GridView remains the same
            final screenPadding = 12.0;
            final itemSpacing = 8.0;
            return GridView.builder(
              padding: EdgeInsets.all(screenPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: itemSpacing,
                mainAxisSpacing: itemSpacing,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                // Pass the fetched ServiceCategory object
                return _ServiceCategoryBox(category: categories[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, stack) => Center(
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.accent, size: 40),
                    const SizedBox(height: 10),
                    Text('حدث خطأ: ${error.toString()}', textAlign: TextAlign.center),
                     const SizedBox(height: 10),
                      ElevatedButton(onPressed: () => _refreshCategories(ref), child: const Text('إعادة المحاولة'))
                  ],
               )
          ),
        ),
      ),
    );
  }
}

// Update the Reusable widget for the category box
class _ServiceCategoryBox extends StatelessWidget {
  // Expect the new ServiceCategory entity
  final ServiceCategory category;

  const _ServiceCategoryBox({required this.category});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // Navigate to sub-services, passing the category ID
        // Ensure the argument type matches what SubServicesScreen expects (int or String)
        Navigator.pushNamed(context, AppRoutes.subServices, arguments: category.id.toString()); // Pass ID as string
      },
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: AppColors.divider),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Use the icon mapper function
            Icon(
              mapServiceIcon(category.icon), // Map the string icon name
              size: 40.0,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12.0),
            Text(
              category.name, // Use name from the category object
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
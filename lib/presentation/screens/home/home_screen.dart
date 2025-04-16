import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/domain/entities/service_category.dart';
import 'package:zaindev_application/presentation/providers/service_provider.dart';
import 'package:zaindev_application/presentation/screens/home/banner_provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../domain/entities/banner_item.dart';


class FeaturedItem {
  final String id;
  final String name;
  final IconData? icon; // For services/categories
  final String? imageUrl; // For projects/products
  FeaturedItem({required this.id, required this.name, this.icon, this.imageUrl});
}


final featuredProjectsProvider = Provider<List<FeaturedItem>>((ref) {
   // Replace with API call
   return [
     FeaturedItem(id: 'p1', name: 'مشروع بناء فيلا', imageUrl: 'https://via.placeholder.com/200x150/CCCCCC/FFFFFF?text=Project+1'),
     FeaturedItem(id: 'p2', name: 'تطوير مجمع سكني', imageUrl: 'https://via.placeholder.com/200x150/AAAAAA/FFFFFF?text=Project+2'),
   ];
});


// Provider for Banner PageView controller state
final bannerPageControllerProvider = Provider.autoDispose<PageController>((ref) {
  return PageController(viewportFraction: 0.9); // Show parts of next/prev banners
});
final bannerCurrentIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

final bottomNavIndexProvider = StateProvider<int>((ref) => 0); // Default to Home (index 0)

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(bannersProvider);
    final serviceCategories = ref.watch(serviceCategoriesProvider);
    final featuredProjects = ref.watch(featuredProjectsProvider);
    
    return ListView( // Use ListView for scrollable content
      padding: const EdgeInsets.only(bottom: 80), // Padding for FAB
      children: [
        // --- Banners Section ---
        // if (banners.isNotEmpty) ,

        banners.when(
      data: (banners) {
        return _buildBannerSlider(context, ref, banners);
      }, 
      error: (error, stack) {
        return Center(
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.accent, size: 40),
                    const SizedBox(height: 10),
                    Text('حدث خطأ: ${error.toString()}', textAlign: TextAlign.center),
                     const SizedBox(height: 10),
                      ElevatedButton(onPressed: () => ref.invalidate(bannersProvider), child: const Text('إعادة المحاولة'))
                  ],
               )
          );
      }, 
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),    
    ),
            const SizedBox(height: 24),

        // --- Featured Services Section ---
        _buildSectionHeader(context, 'خدماتنا', () {
           // Navigate to the Services Tab
           ref.read(bottomNavIndexProvider.notifier).state = 1; // Index of Services tab
        }),
        serviceCategories.when(
      data: (services) {
        return _buildHorizontalList(
          context: context,
          itemCount: services.length,
          itemBuilder: (context, index) => _buildServiceItem(context, services[index]),
        );
      }, 
      error: (error, stack) {
        return Center(
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.accent, size: 40),
                    const SizedBox(height: 10),
                    Text('حدث خطأ: ${error.toString()}', textAlign: TextAlign.center),
                     const SizedBox(height: 10),
                      ElevatedButton(onPressed: () => ref.invalidate(bannersProvider), child: const Text('إعادة المحاولة'))
                  ],
               )
          );
      }, 
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),    
    ),
         const SizedBox(height: 24),

         // --- Featured Projects Section ---
        _buildSectionHeader(context, 'أحدث المشاريع', () {
           Navigator.pushNamed(context, AppRoutes.projects);
        }),
         _buildHorizontalList(
           context: context,
           itemCount: featuredProjects.length,
           itemBuilder: (context, index) => _buildProjectProductItem(context, featuredProjects[index]),
        ),
         const SizedBox(height: 24),

        // Add more sections as needed
      ],
    );

  }

  // --- Helper Widgets for HomePage ---

  Widget _buildBannerSlider(BuildContext context, WidgetRef ref, List<BannerItem> banners) {
     final pageController = ref.watch(bannerPageControllerProvider);
     final currentIndex = ref.watch(bannerCurrentIndexProvider);

     return SizedBox(
       height: 180, // Adjust height as needed
       child: Column(
         children: [
           Expanded(
             child: PageView.builder(
               controller: pageController,
               itemCount: banners.length,
               onPageChanged: (index) {
                 ref.read(bannerCurrentIndexProvider.notifier).state = index;
               },
               itemBuilder: (context, index) {
                 final banner = banners[index];
                 return Container(
                   margin: const EdgeInsets.symmetric(horizontal: 6.0),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(4.0), // Low radius
                       image: DecorationImage(
                         image: NetworkImage(banner.imageUrl), // Use NetworkImage or AssetImage
                         fit: BoxFit.cover,
                         onError: (exception, stackTrace) => const Icon(Icons.error_outline, color: AppColors.accent),
                       ),
                   ),
                    // Optional: Add InkWell for deep linking
                   // child: InkWell(onTap: () => _handleBannerTap(context, banner.deepLink)),
                 );
               },
             ),
           ),
           if (banners.length > 1) ...[
             const SizedBox(height: 8),
             _buildPageIndicator(banners.length, currentIndex),
           ]
         ],
       ),
     );
  }

   Widget _buildPageIndicator(int count, int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          height: 6.0,
          width: currentIndex == index ? 16.0 : 6.0,
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColors.primary : AppColors.disabled.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3.0),
          ),
        );
      }),
    );
  }

   Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onSeeAll) {
      final textTheme = Theme.of(context).textTheme;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: onSeeAll,
              child: const Text('عرض الكل'), // "See All"
            ),
          ],
        ),
      );
   }

   Widget _buildHorizontalList({
      required BuildContext context,
      required int itemCount,
      required Widget Function(BuildContext, int) itemBuilder,
      double height = 130, // Adjust height based on item content
   }) {
      return SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          padding: const EdgeInsets.symmetric(horizontal: 12.0), // Start padding
          itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0), // Padding between items
                  child: itemBuilder(context, index),
              );
          },
        ),
      );
   }

   Widget _buildServiceItem(BuildContext context, ServiceCategory item) {
      final textTheme = Theme.of(context).textTheme;
       return InkWell(
         onTap: () {
            // TODO: Navigate to specific service or category list
            // Navigator.pushNamed(context, AppRoutes.serviceList, arguments: item.id);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigate to ${item.name}')));
         },
         borderRadius: BorderRadius.circular(4.0),
         child: Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4.0), // Low radius
              border: Border.all(color: AppColors.divider.withOpacity(0.5))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.miscellaneous_services ?? Icons.miscellaneous_services, size: 36, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
         ),
       );
   }

   Widget _buildProjectProductItem(BuildContext context, FeaturedItem item, {bool isProduct = false}) {
       final textTheme = Theme.of(context).textTheme;
       return InkWell(
         onTap: () {
            // TODO: Navigate to project details or product details
            // final route = isProduct ? AppRoutes.productDetails : AppRoutes.projectDetails;
            // Navigator.pushNamed(context, route, arguments: item.id);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigate to ${item.name}')));
         },
          borderRadius: BorderRadius.circular(4.0),
         child: Container(
            width: 160, // Wider for images
            decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(4.0),
                 border: Border.all(color: AppColors.divider.withOpacity(0.5))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Expanded(
                   child: Container(
                     decoration: BoxDecoration(
                       borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                       ),
                       image: DecorationImage(
                         image: NetworkImage(item.imageUrl ?? 'https://via.placeholder.com/200x150/E0E0E0/AAAAAA?text=No+Image'),
                         fit: BoxFit.cover,
                         onError: (exception, stackTrace) => const Center(child: Icon(Icons.image_not_supported_outlined, color: AppColors.disabled)),
                       ),
                     ),
                   ),
                 ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      item.name,
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                  ),
                ),
                 // Optional: Add price for products
                 // if (isProduct) Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('SAR 1200', style: textTheme.labelSmall)),
              ],
            ),
         ),
       );
   }

}
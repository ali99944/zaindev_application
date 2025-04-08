import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

import 'package:zaindev_application/presentation/screens/profile/profile_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../services/services_screen.dart';
import 'service_category.dart'; // Import dummy data structure

// Dummy Data (Replace with Providers)
final userProfileProvider = Provider((ref) => {'name': 'زائر', 'avatarUrl': null}); // Example user data
final homeBannersProvider = Provider((ref) => [ // Example banner data
     {'image': 'assets/images/banner_ac_offer.png', 'targetRoute': '/offers/ac'}, // Replace with actual assets/routes
     {'image': 'assets/images/banner_maintenance.png', 'targetRoute': '/services/maintenance'},
     {'image': 'assets/images/banner_new_project.png', 'targetRoute': '/projects/latest'},
]);
final featuredCategoriesProvider = Provider((ref) => dummyServiceCategories.take(4).toList()); // Take first 4 for home
final recentProjectsProvider = Provider((ref) => [ // Example project data
      {'id': 'p1', 'name': 'مشروع تكييف فيلا الرياض', 'image': 'assets/images/project_1.png'},
      {'id': 'p2', 'name': 'تركيب مركزي - برج جدة', 'image': 'assets/images/project_2.png'},
      {'id': 'p3', 'name': 'صيانة دورية - مجمع سكني', 'image': 'assets/images/project_3.png'},
]);
// --- End Dummy Data ---

class HomeScreen extends ConsumerStatefulWidget {
  static const String route = "/home";
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _bannerPageController = PageController();
  int _currentBannerPage = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    // Auto-scroll banner timer (optional)
    final banners = ref.read(homeBannersProvider);
    if (banners.length > 1) {
       _bannerTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
         if (_currentBannerPage < banners.length - 1) {
           _currentBannerPage++;
         } else {
           _currentBannerPage = 0;
         }
         if (_bannerPageController.hasClients) {
            _bannerPageController.animateToPage(
              _currentBannerPage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
            );
         }
       });
    }
  }

   @override
  void dispose() {
    _bannerPageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Fetch data using ref.watch() when using actual providers
    final userData = ref.watch(userProfileProvider);
    final banners = ref.watch(homeBannersProvider);
    final featuredCategories = ref.watch(featuredCategoriesProvider);
    final recentProjects = ref.watch(recentProjectsProvider);
    const double hPadding = 16.0; // Horizontal padding

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}), // Optional Drawer
        centerTitle: true, // Center the logo
        actions: [
          IconButton(
            icon: const HeroIcon(HeroIcons.bell, color: AppColors.black),
            onPressed: () {
              // TODO: Navigate to Notifications Screen
              print('Notifications tapped');
            },
          ),
           IconButton( // Or use leading for profile/menu
            icon: const HeroIcon(HeroIcons.user, color: AppColors.grey),
            onPressed: () {
               Navigator.pushNamed(context, ProfileScreen.route);
            },
          ),
          const SizedBox(width: hPadding / 2),
        ],
      ),
      body: RefreshIndicator( // Optional: Add pull-to-refresh
         onRefresh: () async {
            // TODO: Refresh data from providers
            print('Refreshing home screen data...');
            await Future.delayed(const Duration(seconds: 1)); // Simulate refresh
         },
        child: ListView( // Use ListView instead of SingleChildScrollView for potential Slivers later
          padding: EdgeInsets.zero, // Remove default ListView padding
          children: [
            // --- User Greeting (moved from header) ---
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: hPadding, vertical: 10),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('مرحباً، ${userData['name'] ?? 'زائر'}!', style: textTheme.titleMedium),
                   // Optional: Location - Text('جدة, السعودية', style: textTheme.bodySmall?.copyWith(color: AppColors.grey)),
                 ],
               ),
             ),

             // --- Ad Banner ---
             if (banners.isNotEmpty) _buildBannerCarousel(context, banners),
             const SizedBox(height: 20),

             _buildRequestStatusTracker(
              context,
              textTheme,
             ),


            // --- Request Status Placeholder ---
            // _buildRequestStatusTracker(context, textTheme), // Uncomment to add
            // const SizedBox(height: 20),

            // --- Service Categories Section ---
            _buildSectionHeader(context, textTheme, 'فئات الخدمات', () {
               Navigator.pushNamed(context, AllServiceCategoriesScreen.route);
            }),
            _buildHorizontalServiceList(context, featuredCategories),
            const SizedBox(height: 24),

            // --- Recent Projects Section ---
             _buildSectionHeader(context, textTheme, 'أحدث المشاريع', () {
               // TODO: Navigate to All Projects Screen
               print('View All Projects');
            }),
            _buildHorizontalProjectList(context, recentProjects),
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }

  // --- Helper Widgets for Home Screen Sections ---

  Widget _buildBannerCarousel(BuildContext context, List<Map<String, String>> banners) {
     const double bannerHeight = 160.0;
     const double hPadding = 16.0;

     return SizedBox(
       height: bannerHeight,
       child: PageView.builder(
         controller: _bannerPageController,
         itemCount: banners.length,
         onPageChanged: (page) => setState(() => _currentBannerPage = page),
         itemBuilder: (context, index) {
           final banner = banners[index];
           return GestureDetector(
             onTap: () {
                // TODO: Handle banner tap (navigate to banner['targetRoute'])
                print('Banner tapped: ${banner['targetRoute']}');
             },
             child: Container(
               margin: const EdgeInsets.symmetric(horizontal: hPadding),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(6.0),
                 color: AppColors.lightGrey.withOpacity(0.3), // Placeholder color
                 image: DecorationImage(
                   image: AssetImage(banner['image']!), // Use AssetImage for local assets
                   fit: BoxFit.cover,
                    onError: (exception, stackTrace) => print("Error loading banner image: ${banner['image']}"), // Handle image errors
                 ),
               ),
               // Optional: Add text overlay on banner
             ),
           );
         },
       ),
     );
     // TODO: Add PageIndicator below the PageView if desired
   }


  Widget _buildSectionHeader(BuildContext context, TextTheme textTheme, String title, VoidCallback onViewAll) {
     const double hPadding = 16.0;
     return Padding(
       padding: const EdgeInsets.only(left: hPadding, right: hPadding, bottom: 12.0, top: 8.0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           TextButton(
             onPressed: onViewAll,
             // Style text button for less visual weight if needed
             // style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
             child: const Text('مشاهدة الكل'),
           ),
           Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
         ],
       ),
     );
   }

    Widget _buildHorizontalServiceList(BuildContext context, List<ServiceInfo> categories) {
       const double listHeight = 110.0; // Adjust height based on item size
       const double hPadding = 16.0;

       return SizedBox(
         height: listHeight,
         child: ListView.separated(
           padding: const EdgeInsets.symmetric(horizontal: hPadding),
           scrollDirection: Axis.horizontal,
           itemCount: categories.length,
           separatorBuilder: (context, index) => const SizedBox(width: 10), // Spacing between items
           itemBuilder: (context, index) {
             final category = categories[index];
             return ServiceCategoryItem(
               name: category.name,
               icon: category.icon!,
              //  imageUrl: category.imageUrl,
              //  itemWidth: 90, // Adjust width for horizontal list
               onTap: () {
                 // TODO: Navigate to specific category screen
                  print('Tapped category on home: ${category.name}');
               },
             );
           },
         ),
       );
   }

    Widget _buildHorizontalProjectList(BuildContext context, List<Map<String, String>> projects) {
     const double cardHeight = 150.0;
     const double cardWidth = 220.0;
     const double hPadding = 16.0;

     return SizedBox(
       height: cardHeight,
       child: ListView.separated(
         padding: const EdgeInsets.symmetric(horizontal: hPadding),
         scrollDirection: Axis.horizontal,
         itemCount: projects.length,
         separatorBuilder: (context, index) => const SizedBox(width: 12),
         itemBuilder: (context, index) {
           final project = projects[index];
           return InkWell(
              onTap: () {
                // TODO: Navigate to Project Details Screen
                print('Tapped project: ${project['id']}');
              },
              borderRadius: BorderRadius.circular(6.0),
              child: Container(
                 width: cardWidth,
                 decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(6.0),
                     border: Border.all(color: AppColors.lightGrey.withOpacity(0.5), width: 1),
                    // Placeholder image
                     image: DecorationImage(
                       image: AssetImage(project['image']!),
                       fit: BoxFit.cover,
                       colorFilter: ColorFilter.mode( // Optional: Darken image slightly
                         Colors.black.withOpacity(0.1),
                         BlendMode.darken,
                       ),
                      onError: (exception, stackTrace) => print("Error loading project image: ${project['image']}")
                     )
                 ),
                 child: Align( // Position text at the bottom
                    alignment: Alignment.bottomCenter,
                    child: Container(
                       width: double.infinity,
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                       decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6.0)),
                       ),
                       child: Text(
                          project['name']!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                       ),
                    ),
                 ),
              ),
           );
         },
       ),
     );
   }

    // Optional: Request Status Tracker Widget
   Widget _buildRequestStatusTracker(BuildContext context, TextTheme textTheme) {
     const double hPadding = 16.0;
     return Directionality(
      textDirection: TextDirection.rtl,
       child: Container(
         margin: const EdgeInsets.symmetric(horizontal: hPadding),
         padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppColors.lightPrimary.withOpacity(0.2), // Very light amber
            borderRadius: BorderRadius.circular(6.0),
          ),
         child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text('آخر طلب خدمة: تنظيف مكيف', style: textTheme.titleMedium), // Replace with actual status if available
             const SizedBox(height: 8),
             // --- Add Status Indicator Row here (like Persian app) ---
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 _buildStatusChip('تم التأكيد', AppColors.black), // Example status
                 Text('الثلاثاء 15 أغسطس - 10:00 صباحاً', style: textTheme.bodySmall), // Example date
               ],
             ),
              const SizedBox(height: 8),
              // Placeholder for progress line
              LinearProgressIndicator(
                value: 0.3, // Example progress
                backgroundColor: AppColors.lightGrey.withOpacity(0.5),
                color: AppColors.black,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3), // Add this line
              ),
           ],
         ),
       ),
     );
   }

    Widget _buildStatusChip(String label, Color color) {
       return Container(
         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
         decoration: BoxDecoration(
           color: color.withOpacity(0.15),
           borderRadius: BorderRadius.circular(4),
         ),
         child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
       );
    }


} // End of _HomeScreenState
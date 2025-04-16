import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/project_image.dart';

// Provider to fetch project details (Replace with API)
final projectDetailsProvider = FutureProvider.family.autoDispose<Project?, int>((ref, projectId) async {
   // TODO: Implement API call to fetch project details by projectId
   print("Fetching details for project: $projectId");
   await Future.delayed(const Duration(seconds: 1));
    // Dummy Data (Find the project from the dummy list or return null):
   final dummyList = [
      Project(
         id: 1,
         name: 'Project 1',
         description: 'Description for Project 1',
         mainImageUrl: 'https://via.placeholder.com/600x400',
         technologies: ['Flutter', 'Dart'],
         projectImages: [
            ProjectImage(id:1, imageUrl: 'https://via.placeholder.com/600x400'),
            ProjectImage(id:2, imageUrl: 'https://via.placeholder.com/600x400'),
            ProjectImage(id:3, imageUrl: 'https://via.placeholder.com/600x400'),
         ],
      ),
      Project(
         id: 2,
         name: 'Project 2',
         description: 'Description for Project 2',
         mainImageUrl: 'https://via.placeholder.com/600x400',
         technologies: ['Flutter', 'Dart'],
         projectImages: [
            ProjectImage(id:1, imageUrl: 'https://via.placeholder.com/600x400'),
            ProjectImage(id:2, imageUrl: 'https://via.placeholder.com/600x400'),
            ProjectImage(id:3, imageUrl: 'https://via.placeholder.com/600x400'),
         ],
      ),
   ];
   try {
     return dummyList.firstWhere((p) => p.id == projectId);
   } catch (e) {
      return null; // Not found
   }
});


class ProjectDetailsScreen extends ConsumerWidget {
  final int projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsyncValue = ref.watch(projectDetailsProvider(projectId));
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
       textDirection: TextDirection.rtl,
       child: Scaffold(
          body: detailsAsyncValue.when(
            data: (project) {
              if (project == null) {
                 return Scaffold(appBar: AppBar(), body: const Center(child: Text('المشروع غير موجود.')));
              }
              return CustomScrollView(
                 slivers: [
                    SliverAppBar(
                       expandedHeight: 250.0,
                       floating: false,
                       pinned: true,
                       backgroundColor: AppColors.primary,
                       flexibleSpace: FlexibleSpaceBar(
                          title: Text(project.name, style: const TextStyle(color: Colors.white, fontSize: 14.0), textAlign: TextAlign.right), // Adjust size/alignment
                          background: Image.network(
                             project.mainImageUrl,
                             fit: BoxFit.cover,
                             errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.business_center_outlined, color: AppColors.disabled, size: 50)),
                          ),
                       ),
                    ),
                    SliverPadding(
                       padding: const EdgeInsets.all(16.0),
                       sliver: SliverList(
                          delegate: SliverChildListDelegate([
                             // --- Key Info Section ---
                             _buildKeyInfoSection(context, project),
                             const Divider(height: 24),

                             // --- Description ---
                             Text('عن المشروع', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                             const SizedBox(height: 8),
                             Text(project.description ?? '', style: textTheme.bodyLarge?.copyWith(height: 1.6, color: AppColors.textSecondary)),
                             const Divider(height: 24),

                             // --- Technologies Used ---
                             if ((project.technologies ?? []).isNotEmpty) ...[
                                Text('التقنيات المستخدمة', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Wrap(
                                   spacing: 6.0,
                                   runSpacing: 4.0,
                                   children: (project.technologies ?? []).map((tech) => Chip(
                                      label: Text(tech),
                                      backgroundColor: AppColors.primary.withOpacity(0.1),
                                      labelStyle: textTheme.bodySmall?.copyWith(color: AppColors.primary),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      visualDensity: VisualDensity.compact,
                                      side: BorderSide.none,
                                   )).toList(),
                                ),
                                const Divider(height: 24),
                             ],

                             // --- Project Images ---
                             if ((project.projectImages ?? []).isNotEmpty) ...[
                                Text('صور المشروع', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 12),
                                SizedBox(
                                   height: 150, // Adjust height for image previews
                                   child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: (project.projectImages ?? []).length,
                                      itemBuilder: (context, index) {
                                         final img = project.projectImages?[index];
                                         return Padding(
                                            padding: const EdgeInsetsDirectional.only(end: 8.0),
                                            child: InkWell(
                                               onTap: () {
                                                   // TODO: Implement full-screen image viewer
                                                   showDialog(context: context, builder: (_) => Dialog(child: Image.network(img?.imageUrl ?? '')));
                                               },
                                               child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(4.0),
                                                  child: Image.network(
                                                     img?.imageUrl ?? '',
                                                     width: 200, // Adjust width
                                                     fit: BoxFit.cover,
                                                     errorBuilder: (context, error, stackTrace) => Container(width: 200, color: AppColors.disabled.withOpacity(0.2), child: const Icon(Icons.error_outline)),
                                                  ),
                                               ),
                                            ),
                                         );
                                      },
                                   ),
                                ),
                                const SizedBox(height: 16), // Bottom padding after images
                             ]
                          ]),
                       ),
                    ),
                 ],
              );
            },
            loading: () => Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator(color: AppColors.primary))),
            error: (error, stack) => Scaffold(appBar: AppBar(), body: Center(child: Text('خطأ: $error'))),
          ),
       ),
    );
  }

  // Helper for Key Info section
  Widget _buildKeyInfoSection(BuildContext context, Project project) {
     return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
           color: AppColors.secondary.withOpacity(0.1),
           borderRadius: BorderRadius.circular(4)
        ),
        child: Wrap( // Use Wrap for responsiveness
           spacing: 16.0, // Horizontal space
           runSpacing: 12.0, // Vertical space
           alignment: WrapAlignment.spaceBetween,
           children: [
              _buildInfoItem(context, Icons.person_outline, 'العميل', project.client ?? ''),
              _buildInfoItem(context, Icons.calendar_today_outlined, 'تاريخ الإنجاز', project.completionDate ?? ''),
              _buildInfoItem(context, Icons.category_outlined, 'نوع المشروع', project.projectType ?? ''),
              _buildInfoItem(context, Icons.bookmark_border_outlined, 'التصنيف', project.categoryInfo ?? ''),
           ],
        ),
     );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value) {
     final textTheme = Theme.of(context).textTheme;
     return Row(
        mainAxisSize: MainAxisSize.min, // Take minimum space needed
        children: [
           Icon(icon, size: 18, color: AppColors.primary),
           const SizedBox(width: 6),
           Text('$label: ', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
           Flexible(child: Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))), // Allow value to wrap if needed
        ],
     );
  }
}
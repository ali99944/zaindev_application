import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../domain/entities/project.dart';
import '../../providers/project_provider.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  Future<void> _refreshProjects(WidgetRef ref) async {
     ref.invalidate(projectsProvider); // Invalidate the list provider
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the new provider
    final projectsAsyncValue = ref.watch(projectsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مشاريعنا')),
        body: RefreshIndicator(
          onRefresh: () => _refreshProjects(ref),
          color: AppColors.primary,
          child: projectsAsyncValue.when(
             data: (projects) {
                 if (projects.isEmpty) {
                    return const Center(child: Text('لا توجد مشاريع لعرضها حالياً.'));
                 }
                 // GridView remains similar
                 final screenPadding = 12.0;
                 final itemSpacing = 8.0;
                 return GridView.builder(
                    padding: EdgeInsets.all(screenPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: itemSpacing,
                      mainAxisSpacing: itemSpacing,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      // Pass the fetched Project object
                      return _ProjectGridItem(project: projects[index]);
                    },
                  );
             },
             // Use reusable loading/error widgets
             loading: () => const CircularProgressIndicator(),
             error: (error, stack) => Text(error.toString()),
          ),
        ),
      ),
    );
  }
}

// --- Reusable Project Grid Item ---
class _ProjectGridItem extends StatelessWidget {
   final Project project; // Expect Project entity
   const _ProjectGridItem({required this.project});

  @override
  Widget build(BuildContext context) {
     final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
         // Navigate passing the project ID
         Navigator.pushNamed(context, AppRoutes.projectDetails, arguments: project.id);
      },
       borderRadius: BorderRadius.circular(4.0),
      child: Container(
         // ... (Decoration as before) ...
         decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: AppColors.divider.withOpacity(0.5)),
              color: AppColors.background,
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
                  // Use project.mainImageUrl
                  child: Image.network(
                    project.mainImageUrl,
                    fit: BoxFit.cover,
                    // ... (Error and Loading builder as before) ...
                     errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.business_center_outlined, color: AppColors.disabled)), // Use appropriate icon
                    //  loadingBuilder:(context, child, loadingProgress) { /* ... */ },
                  ),
                ),
              ),
             Expanded(
               flex: 2,
               child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                        // Use project.name
                        Text(
                           project.name,
                           style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Use project.categoryInfo or projectType
                        Text(
                           project.categoryInfo ?? project.projectType ?? '',
                           style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
                     ],
                  ),
               ),
             ),
           ],
         ),
      ),
    );
  }
}
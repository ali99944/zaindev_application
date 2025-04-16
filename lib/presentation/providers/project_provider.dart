import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/remote/project_repository_impl.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/remote/project_repository.dart';
import '../screens/auth/auth_providers.dart';

// Repository Provider
final projectRepositoryProvider = Provider<IProjectRepository>((ref) {
  return ProjectRepositoryImpl(ref.watch(apiHelperProvider));
});

// Provider to fetch ALL projects list
final projectsProvider = FutureProvider.autoDispose<List<Project>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getProjects();
});

// Provider to fetch FEATURED projects list (for home screen maybe)
final featuredProjectsProvider = FutureProvider.autoDispose<List<Project>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getProjects(featuredOnly: true);
});


// Provider to fetch project details based on ID
final projectDetailsProvider = FutureProvider.family.autoDispose<Project, int>((ref, projectId) async {
   final repository = ref.watch(projectRepositoryProvider);
   return repository.getProjectDetails(projectId);
});
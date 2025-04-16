import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/remote/service_category_repository_impl.dart';
import '../../../domain/entities/service_category.dart';
import '../../../domain/repositories/remote/service_category_repository.dart';
import '../auth/auth_providers.dart';

// Provider for the repository implementation
final serviceCategoryRepositoryProvider = Provider<IServiceCategoryRepository>((ref) {
  // Assuming apiHelperProvider provides ApiHelper instance
  return ServiceCategoryRepositoryImpl(ref.watch(apiHelperProvider));
});

// FutureProvider to fetch the categories list
final serviceCategoriesProvider = FutureProvider.autoDispose<List<ServiceCategory>>((ref) async {
  final repository = ref.watch(serviceCategoryRepositoryProvider);
  return repository.getServiceCategories();
});


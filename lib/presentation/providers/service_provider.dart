import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/remote/service_category_repository_impl.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/sub_service.dart';
import '../../domain/repositories/remote/service_category_repository.dart';
import '../screens/auth/auth_providers.dart';


// Repository Provider (as before)
final serviceCategoryRepositoryProvider = Provider<IServiceCategoryRepository>((ref) {
  return ServiceCategoryRepositoryImpl(ref.watch(apiHelperProvider));
});

final serviceCategoriesProvider = FutureProvider.autoDispose<List<ServiceCategory>>((ref) async {
  final repository = ref.watch(serviceCategoryRepositoryProvider);
  return repository.getServiceCategories();
});

// --- Sub-Services Providers ---

// Provider to fetch sub-services list based on category ID
final subServicesProvider = FutureProvider.family.autoDispose<List<SubService>, String>((ref, categoryId) async {
  final repository = ref.watch(serviceCategoryRepositoryProvider);
  return repository.getSubServices(categoryId);
});

// Provider to fetch sub-service details based on service ID
final subServiceDetailsProvider = FutureProvider.family.autoDispose<SubServiceDetails, String>((ref, serviceId) async {
   final repository = ref.watch(serviceCategoryRepositoryProvider);
   return repository.getSubServiceDetails(serviceId);
});

// Optional: Provider to get category name (if needed frequently)
final serviceCategoryNameProvider = FutureProvider.family.autoDispose<String?, String>((ref, categoryId) async {
   // Option 1: Fetch all categories and find name (caches categories)
   final categories = await ref.watch(serviceCategoriesProvider.future);
   try {
      return categories.firstWhere((cat) => cat.id.toString() == categoryId).name;
   } catch (_) {
      return null; // Not found
   }
   // Option 2: Make a separate API call to fetch single category details if needed
});
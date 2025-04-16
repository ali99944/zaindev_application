import '../../../core/utils/api_helper.dart';
import '../../../core/utils/logger.dart';
import '../../../core/utils/parse_error.dart';
import '../../../domain/entities/service_category.dart';
import '../../../domain/entities/sub_service.dart';
import '../../../domain/repositories/remote/service_category_repository.dart';

class ServiceCategoryRepositoryImpl implements IServiceCategoryRepository {
  final ApiHelper _apiHelper;

  ServiceCategoryRepositoryImpl(this._apiHelper);

  @override
  Future<List<ServiceCategory>> getServiceCategories() async {
    try {
      // Assuming getData returns List<dynamic> when the JSON root is an array
      final responseData = await _apiHelper.getData<List<dynamic>>('service-categories');
      pinfo(responseData);

      // Map the dynamic list to a list of ServiceCategory objects
      final categories = responseData
          .map((categoryJson) => ServiceCategory.fromJson(categoryJson as Map<String, dynamic>))
          .toList();

      return categories;
    } catch (e) {
      perror("GetServiceCategories Error: $e");
      // Re-throw a user-friendly error or the parsed error
      throw parseApiError(e);
    }
  }


  @override
  Future<List<SubService>> getSubServices(String categoryId) async {
    try {
      final responseData = await _apiHelper.getData<List<dynamic>>(
        'service-categories/$categoryId/sub-services' // Correct endpoint
      );
      final subServices = responseData
          .map((subServiceJson) => SubService.fromListJson(subServiceJson as Map<String, dynamic>)) // Use correct factory
          .toList();
      return subServices;
    } catch (e) {
      perror("GetSubServices Error (Category $categoryId): $e");
      throw parseApiError(e);
    }
  }

   @override
   Future<SubServiceDetails> getSubServiceDetails(String serviceId) async {
     try {
      // Expecting a Map for a single object
       final responseData = await _apiHelper.getData<Map<String, dynamic>>(
         'sub-services/$serviceId' // Correct endpoint
       );
       return SubServiceDetails.fromJson(responseData); // Use detail factory
     } catch (e) {
       perror("GetSubServiceDetails Error (Service $serviceId): $e");
       throw parseApiError(e);
     }
   }
}
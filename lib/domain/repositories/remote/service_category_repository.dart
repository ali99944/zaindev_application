import '../../entities/service_category.dart';
import '../../entities/sub_service.dart';


abstract class IServiceCategoryRepository {
  Future<List<ServiceCategory>> getServiceCategories();
  Future<List<SubService>> getSubServices(String categoryId); // Changed argument to String
  Future<SubServiceDetails> getSubServiceDetails(String serviceId); // Changed argument & return type
}
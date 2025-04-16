import '../../entities/banner_item.dart';

abstract class IBannerRepository {
  Future<List<BannerItem>> getBanners();
}
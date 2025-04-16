import 'dart:convert';

import 'package:zaindev_application/domain/repositories/remote/banner_repository.dart';

import '../../../core/utils/api_helper.dart';
import '../../../core/utils/logger.dart';
import '../../../core/utils/parse_error.dart';
import '../../../domain/entities/banner_item.dart';

class BannerRepositoryImpl implements IBannerRepository {
  final ApiHelper _apiHelper;

  BannerRepositoryImpl(this._apiHelper); // Inject dependencies

  @override
  Future<List<BannerItem>> getBanners() async {
    try {
      final responseData = await _apiHelper.getData<List<dynamic>>('banners');
      pinfo(responseData);
      final banners = responseData
          .map((bannerJson) => BannerItem.fromJson(bannerJson as Map<String, dynamic>))
          .toList();
      return banners;
    } catch (e) {
      perror("GetBanners Error: $e");
      throw parseApiError(e);
    }
  }
}
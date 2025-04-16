import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/data/repositories/remote/banner_repository_impl.dart';
import 'package:zaindev_application/domain/repositories/remote/banner_repository.dart';

import '../../../domain/entities/banner_item.dart';
import '../auth/auth_providers.dart'; // Import serviceCategoryRepositoryProvider

// Provider for Home Repository Implementation
final bannerRepositoryProvider = Provider<IBannerRepository>((ref) {
  return BannerRepositoryImpl(
    ref.watch(apiHelperProvider),
  );
});

// FutureProvider for Banners
final bannersProvider = FutureProvider.autoDispose<List<BannerItem>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getBanners();
});

final bannerPageControllerProvider = Provider.autoDispose<PageController>((ref) {
  return PageController(viewportFraction: 0.9);
});
final bannerCurrentIndexProvider = StateProvider.autoDispose<int>((ref) => 0);
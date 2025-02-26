// home_repo_impl.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/domain/repos/home_repo.dart';
import 'package:in_pocket/features/home/services/home_api_service.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeService homeService;

  HomeRepoImpl({required this.homeService});

  @override
  Future<Either<Failure, HomeEntity>> getHomeData({
    required int announcementsPage,
    required int announcementsCount,
    required int storesPage,
    required int storesCount,
    required int couponsPage,
    required int couponsCount,
  }) async {
    try {
      final homeData = await homeService.getHomeData(
        announcementsPage: announcementsPage,
        announcementsCount: announcementsCount,
        storesPage: storesPage,
        storesCount: storesCount,
        couponsPage: couponsPage,
        couponsCount: couponsCount,
      );
      return right(homeData);
    } catch (e) {
      log('Error in HomeRepoImpl.getHomeData: $e');
      return left(ServerFaliure(message: e.toString()));
    }
  }
}

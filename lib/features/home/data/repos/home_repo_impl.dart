import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/core/service/home_api_service.dart';
import 'package:in_pocket/features/home/domain/mapper/home_mapper.dart';
import 'package:in_pocket/features/home/data/models/home_model.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/domain/repos/home_repo.dart';

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
      // 1) Get the Data-layer model
      final HomeModel homeModel = await homeService.getHomeData(
        announcementsPage: announcementsPage,
        announcementsCount: announcementsCount,
        storesPage: storesPage,
        storesCount: storesCount,
        couponsPage: couponsPage,
        couponsCount: couponsCount,
      );

      // 2) Map Data -> Domain using the dedicated mapper
      final HomeEntity homeEntity = HomeMapper.mapToEntity(homeModel);

      // 3) Return success
      return Right(homeEntity);
    } catch (e) {
      log('Error in HomeRepoImpl.getHomeData: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }
}

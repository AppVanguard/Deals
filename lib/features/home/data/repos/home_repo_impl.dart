import 'package:deals/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/features/home/data/models/home_model/home_model.dart';
import 'package:deals/features/home/domain/mapper/home_mapper.dart';
import 'package:deals/features/home/domain/entities/home_entity.dart';
import 'package:deals/features/home/domain/repos/home_repo.dart';
import 'package:deals/core/service/home_api_service.dart';
import 'package:deals/features/home/data/datasources/home_local_data_source.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeService homeService;
  final HomeLocalDataSource localDataSource;

  HomeRepoImpl({
    required this.homeService,
    required this.localDataSource,
  });

  /// Fetch only from the local cache. Return Failure if no cache is present.
  @override
  Future<Either<Failure, HomeEntity>> getCachedData() async {
    try {
      final cachedModel = localDataSource.getCachedHomeData();
      if (cachedModel != null) {
        final cachedEntity = HomeMapper.mapToEntity(cachedModel);
        return Right(cachedEntity);
      } else {
        return Left(ServerFailure(message: 'No cached home data found'));
      }
    } catch (e) {
      appLog('Error reading cache: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Fetch from remote, cache if success. Return the newly fetched data or Failure if fails.
  @override
  Future<Either<Failure, HomeEntity>> getFreshData({
    required int announcementsPage,
    required int announcementsCount,
    required int storesPage,
    required int storesCount,
    required int couponsPage,
    required int couponsCount,
    required String token,
  }) async {
    try {
      final HomeModel remoteModel = await homeService.getHomeData(
        token: token,
        announcementsPage: announcementsPage,
        announcementsCount: announcementsCount,
        storesPage: storesPage,
        storesCount: storesCount,
        couponsPage: couponsPage,
        couponsCount: couponsCount,
      );
      // Cache it
      await localDataSource.cacheHomeData(remoteModel);
      // Map to domain
      final homeEntity = HomeMapper.mapToEntity(remoteModel);
      return Right(homeEntity);
    } catch (e) {
      appLog('Error fetching remote: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

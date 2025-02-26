// home_repo.dart
import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';

abstract class HomeRepo {
  Future<Either<Failure, HomeEntity>> getHomeData({
    required int announcementsPage,
    required int announcementsCount,
    required int storesPage,
    required int storesCount,
    required int couponsPage,
    required int couponsCount,
  });
}

import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/errors/faliure.dart';

abstract class StoresRepo {
  Future<Either<Failure, List<StoreEntity>>> getAllStores({
    String? search,
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
  });
  Future<Either<Failure, StoreEntity>> getStoreById(String id);
}

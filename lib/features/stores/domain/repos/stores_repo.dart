import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/features/stores/domain/repos/stores_with_pagination.dart';
// ...

abstract class StoresRepo {
  Future<Either<Failure, StoresWithPaginationEntity>> getAllStores(
      {String? search,
      String? sortField,
      int? page,
      int? limit,
      String? sortOrder,
      String? categoryId,
      required String token});

  Future<Either<Failure, StoreEntity>> getStoreById(String id, String token);
}

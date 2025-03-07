import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/stores/domain/repos/stores_with_pagination.dart';
// ...

abstract class StoresRepo {
  Future<Either<Failure, StoresWithPaginationEntity>> getAllStores({
    String? search,
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
  });

  Future<Either<Failure, StoreEntity>> getStoreById(String id);
}

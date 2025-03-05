import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/errors/faliure.dart';

abstract class StoresRepo {
  Future<Either<Failure, List<StoreEntity>>> getAllStores({String? search, int? page, int? limit});
  Future<Either<Failure, StoreEntity>> getStoreById(String id);
}
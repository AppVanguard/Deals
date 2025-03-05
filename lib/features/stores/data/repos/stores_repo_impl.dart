import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/service/stores_api_service.dart';
import 'package:deals/features/stores/data/models/stores_model/stores_model.dart';
import 'package:deals/features/stores/domain/mapper/stores_mapper.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';

class StoresRepoImpl implements StoresRepo {
  final StoresService storesService;

  StoresRepoImpl({required this.storesService});

  @override
  Future<Either<Failure, List<StoreEntity>>> getAllStores({
    String? search,
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
  }) async {
    try {
      // 1) Fetch the data model with the provided parameters.
      final StoresModel storesModel = await storesService.getAllStores(
        search: search,
        sortField: sortField,
        page: page,
        limit: limit,
        sortOrder: sortOrder,
      );

      // 2) Map the data model to a list of domain entities.
      final List<StoreEntity> storeEntities =
          StoresMapper.mapToEntities(storesModel);

      // 3) Return the mapped entities wrapped in a Right.
      return Right(storeEntities);
    } catch (e) {
      log('Error in StoresRepoImpl.getAllStores: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoreEntity>> getStoreById(String id) async {
    try {
      // 1) Fetch the data model by ID.
      final StoresModel storesModel = await storesService.getStoreById(id);

      // 2) Check if the model contains data and map the first item.
      if (storesModel.data != null && storesModel.data!.isNotEmpty) {
        final StoreEntity storeEntity =
            StoresMapper.mapToEntity(storesModel.data!.first);
        return Right(storeEntity);
      } else {
        throw Exception('Store not found');
      }
    } catch (e) {
      log('Error in StoresRepoImpl.getStoreById: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }
}

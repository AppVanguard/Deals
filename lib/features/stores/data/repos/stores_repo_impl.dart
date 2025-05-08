// lib/features/stores/data/repos/stores_repo_impl.dart

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/mappers/pagination_mapper.dart';
import 'package:deals/core/service/stores_service.dart';
import 'package:deals/features/stores/data/models/stores_model.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/stores/domain/mapper/stores_mapper.dart';
import 'package:deals/features/stores/domain/repos/stores_with_pagination.dart';

class StoresRepoImpl implements StoresRepo {
  final StoresService storesService;

  StoresRepoImpl({required this.storesService});

  @override
  Future<Either<Failure, StoresWithPaginationEntity>> getAllStores({
    String? search,
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
    String? categoryId,
    required String token,
  }) async {
    try {
      // 1) Fetch the data-layer model from the service
      final StoresModel storesModel = await storesService.getAllStores(
        search: search,
        sortField: sortField,
        page: page,
        limit: limit,
        sortOrder: sortOrder,
        categoryId: categoryId,
        token: token,
      );

      // 2) Map the 'data' to domain store entities
      final List<StoreEntity> storeEntities =
          StoresMapper.mapToEntities(storesModel);

      // 3) Map the 'pagination' to domain pagination entity
      final paginationModel =
          storesModel.pagination; // data-layer 'Pagination'?
      // It's possible that paginationModel is null if the API doesn't send it.
      // Provide a default if needed:
      final PaginationEntity paginationEntity = paginationModel == null
          ? const PaginationEntity(
              currentPage: 1,
              totalPages: 1,
              totalStores: 0,
              hasNextPage: false,
              hasPrevPage: false,
            )
          : PaginationMapper.mapToEntity(paginationModel);

      // 4) Bundle everything into a single aggregator
      final result = StoresWithPaginationEntity(
        stores: storeEntities,
        pagination: paginationEntity,
      );

      return Right(result);
    } catch (e) {
      log('Error in StoresRepoImpl.getAllStores: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoreEntity>> getStoreById(
      String id, String token) async {
    try {
      final StoresModel storesModel =
          await storesService.getStoreById(id, token);

      if (storesModel.data != null && storesModel.data!.isNotEmpty) {
        final storeEntity = StoresMapper.mapToEntity(storesModel.data!.first);
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

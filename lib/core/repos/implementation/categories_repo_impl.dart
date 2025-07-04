import 'package:deals/core/utils/logger.dart';

import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/category_entity.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/mappers/category_mapper.dart';
import 'package:deals/core/mappers/pagination_mapper.dart';
import 'package:deals/core/models/category_model/category_model.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/repos/interface/categories_with_pagination_entity.dart';
import 'package:deals/core/service/category_service.dart';

class CategoriesRepoImpl implements CategoriesRepo {
  final CategoriesService categoriesService;

  CategoriesRepoImpl({required this.categoriesService});

  @override
  Future<Either<Failure, CategoriesWithPaginationEntity>> getAllCategories({
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
    required String token,
  }) async {
    try {
      // 1) Fetch the data-layer model from the service.
      final CategoryModel categoryModel =
          await categoriesService.getAllCategories(
        token: token,
        sortField: sortField,
        page: page,
        limit: limit,
        sortOrder: sortOrder,
      );

      // 2) Map each category in the data list directly using the CategoryMapper.
      final List<CategoryEntity> categoryEntities = categoryModel.data == null
          ? <CategoryEntity>[]
          : categoryModel.data!
              .map((data) => CategoryMapper.mapToEntity(data))
              .toList();

      // 3) Map the pagination model using the PaginationMapper.
      final paginationModel = categoryModel.pagination;
      final PaginationEntity paginationEntity = paginationModel == null
          ? const PaginationEntity(
              currentPage: 1,
              totalPages: 1,
              totalStores: 0,
              hasNextPage: false,
              hasPrevPage: false,
            )
          : PaginationMapper.mapToEntity(paginationModel);

      // 4) Bundle everything into an aggregated domain object.
      final result = CategoriesWithPaginationEntity(
        categories: categoryEntities,
        pagination: paginationEntity,
      );

      return Right(result);
    } catch (e) {
      appLog('Error in CategoriesRepoImpl.getAllCategories: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
      String id, String token) async {
    try {
      final CategoryModel categoryModel =
          await categoriesService.getCategoryById(id, token);

      if (categoryModel.data != null && categoryModel.data!.isNotEmpty) {
        final categoryEntity =
            CategoryMapper.mapToEntity(categoryModel.data!.first);
        return Right(categoryEntity);
      } else {
        throw Exception('Category not found');
      }
    } catch (e) {
      appLog('Error in CategoriesRepoImpl.getCategoryById: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

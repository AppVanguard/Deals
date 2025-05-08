import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/category_entity.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/errors/faliure.dart';
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

      // 2) Map each category in the data list using the CategoryMapper.
      //    Note: The provided mapper maps using `categoryModel.data?.first`
      //    so we create a temporary CategoryModel for each item.
      final List<CategoryEntity> categoryEntities = [];
      if (categoryModel.data != null && categoryModel.data!.isNotEmpty) {
        for (var data in categoryModel.data!) {
          final singleCategoryModel = CategoryModel(
            data: [data],
            pagination: categoryModel.pagination,
          );
          categoryEntities.add(CategoryMapper.mapToEntity(singleCategoryModel));
        }
      }

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
      log('Error in CategoriesRepoImpl.getAllCategories: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
      String id, String token) async {
    try {
      final CategoryModel categoryModel =
          await categoriesService.getCategoryById(id, token);

      if (categoryModel.data != null && categoryModel.data!.isNotEmpty) {
        final categoryEntity = CategoryMapper.mapToEntity(categoryModel);
        return Right(categoryEntity);
      } else {
        throw Exception('Category not found');
      }
    } catch (e) {
      log('Error in CategoriesRepoImpl.getCategoryById: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }
}

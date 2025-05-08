import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/category_entity.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/repos/interface/categories_with_pagination_entity.dart';

abstract class CategoriesRepo {
  Future<Either<Failure, CategoriesWithPaginationEntity>> getAllCategories({
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
    required String token,
  });

  Future<Either<Failure, CategoryEntity>> getCategoryById(
      String id, String token);
}

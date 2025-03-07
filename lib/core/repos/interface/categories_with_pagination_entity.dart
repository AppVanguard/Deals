import 'package:deals/core/entities/category_entity.dart';
import 'package:deals/core/entities/pagination_entity.dart';

class CategoriesWithPaginationEntity {
  final List<CategoryEntity> categories;
  final PaginationEntity pagination;

  CategoriesWithPaginationEntity({
    required this.categories,
    required this.pagination,
  });
}

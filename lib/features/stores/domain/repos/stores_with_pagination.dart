import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/entities/store_entity.dart';

class StoresWithPaginationEntity {
  final List<StoreEntity> stores;
  final PaginationEntity pagination;

  StoresWithPaginationEntity({
    required this.stores,
    required this.pagination,
  });
}

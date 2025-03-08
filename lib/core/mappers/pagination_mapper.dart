// pagination_mapper.dart

import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/models/pagination.dart';

class PaginationMapper {
  /// Maps a data-layer [Pagination] model into the domain-layer [PaginationEntity].
  static PaginationEntity mapToEntity(Pagination paginationModel) {
    return PaginationEntity(
      currentPage: paginationModel.currentPage ?? 1,
      totalPages: paginationModel.totalPages ?? 1,
      totalStores: paginationModel.totlaStores ?? 0,
      totalCategories: paginationModel.totalCategories ?? 0,
      totalCoupons: paginationModel.totalCoupons ?? 0,
      hasNextPage: paginationModel.hasNextPage ?? false,
      hasPrevPage: paginationModel.hasPrevPage ?? false,
    );
  }

  /// (Optional) Maps a domain-layer [PaginationEntity] back to the data-layer [Pagination] model.
  /// Only implement if needed (e.g., for sending updated pagination data back to the server).
  static Pagination mapToModel(PaginationEntity paginationEntity) {
    return Pagination(
      currentPage: paginationEntity.currentPage,
      totalPages: paginationEntity.totalPages,
      totalCategories: paginationEntity.totalCategories,
      totalCoupons: paginationEntity.totalCoupons,
      totlaStores: paginationEntity.totalStores,
      hasNextPage: paginationEntity.hasNextPage,
      hasPrevPage: paginationEntity.hasPrevPage,
    );
  }
}

import 'package:deals/features/bookmarks/data/bookmark_model/pagination.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_pagination_entity.dart';

/// Converts the raw data-layer [Pagination] into our domain [BookmarkPaginationEntity].
class BookmarkPaginationMapper {
  static BookmarkPaginationEntity mapToEntity(Pagination model) {
    return BookmarkPaginationEntity(
      currentPage: model.pageNumber ?? 1,
      pageSize: model.pageSize ?? 0,
      itemsCount: model.itemsCount ?? 0,
      totalPages: model.totalPages ?? 1,
    );
  }
}

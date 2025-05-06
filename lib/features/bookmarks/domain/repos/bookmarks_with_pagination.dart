import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';

class BookmarksWithPaginationEntity {
  final List<BookmarkEntity> bookmarks;
  final PaginationEntity pagination;

  const BookmarksWithPaginationEntity({
    required this.bookmarks,
    required this.pagination,
  });
}

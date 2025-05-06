import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_pagination_entity.dart';

class BookmarksWithPaginationEntity {
  final List<BookmarkEntity> bookmarks;
  final BookmarkPaginationEntity pagination;

  const BookmarksWithPaginationEntity({
    required this.bookmarks,
    required this.pagination,
  });
}

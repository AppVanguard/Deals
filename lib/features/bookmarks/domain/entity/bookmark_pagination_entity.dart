// lib/features/bookmarks/domain/entities/bookmark_pagination_entity.dart

/// A lean domain entity for pagination info in the bookmarks feature.
class BookmarkPaginationEntity {
  /// The current page (1-based).
  final int currentPage;

  /// Number of items per page.
  final int pageSize;

  /// Total number of items across all pages.
  final int itemsCount;

  /// Total number of pages available.
  final int totalPages;

  const BookmarkPaginationEntity({
    required this.currentPage,
    required this.pageSize,
    required this.itemsCount,
    required this.totalPages,
  });
}

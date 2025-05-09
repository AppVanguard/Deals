part of 'bookmark_cubit.dart';

@immutable
abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkSuccess extends BookmarkState {
  final List<BookmarkEntity> bookmarks;
  final BookmarkPaginationEntity pagination;
  final bool isLoadingMore;

  BookmarkSuccess({
    required this.bookmarks,
    required this.pagination,
    this.isLoadingMore = false,
  });

  BookmarkSuccess copyWith({
    List<BookmarkEntity>? bookmarks,
    BookmarkPaginationEntity? pagination,
    bool? isLoadingMore,
  }) =>
      BookmarkSuccess(
        bookmarks: bookmarks ?? this.bookmarks,
        pagination: pagination ?? this.pagination,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class BookmarkFailure extends BookmarkState {
  final String message;
  BookmarkFailure({required this.message});
}

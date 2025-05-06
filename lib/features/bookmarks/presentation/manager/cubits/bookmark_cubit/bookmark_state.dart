part of 'bookmark_cubit.dart';

@immutable
abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkSuccess extends BookmarkState {
  final List<BookmarkEntity> bookmarks;
  final BookmarkPaginationEntity pagination;

  BookmarkSuccess({
    required this.bookmarks,
    required this.pagination,
  });

  BookmarkSuccess copyWith({
    List<BookmarkEntity>? bookmarks,
    BookmarkPaginationEntity? pagination,
  }) {
    return BookmarkSuccess(
      bookmarks: bookmarks ?? this.bookmarks,
      pagination: pagination ?? this.pagination,
    );
  }
}

class BookmarkFailure extends BookmarkState {
  final String message;
  BookmarkFailure({required this.message});
}

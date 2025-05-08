import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_pagination_entity.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmarks_with_pagination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmark_repo.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepo bookmarkRepo;
  final String firebaseUid;

  BookmarkCubit({
    required this.bookmarkRepo,
    required this.firebaseUid,
  }) : super(BookmarkInitial()) {
    loadBookmarks();
  }

  /// 1) Load (or refresh) the list of bookmarks
  Future<void> loadBookmarks({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(BookmarkLoading());
    }
    final user = await SecureStorageService.getCurrentUser();

    final Either<Failure, BookmarksWithPaginationEntity> result =
        await bookmarkRepo.getUserBookmarks(firebaseUid, user!.token);

    result.fold(
      (failure) => emit(BookmarkFailure(message: failure.message)),
      (paginated) {
        emit(BookmarkSuccess(
          bookmarks: paginated.bookmarks,
          pagination: paginated.pagination,
        ));
      },
    );
  }

  /// 2) Create a new bookmark, then prepend it to the current list
  Future<void> addBookmark(String storeId) async {
    emit(BookmarkLoading());
    final user = await SecureStorageService.getCurrentUser();

    final Either<Failure, BookmarkEntity> result =
        await bookmarkRepo.createBookmark(
            firebaseUid: firebaseUid, storeId: storeId, token: user!.token);

    result.fold(
      (failure) => emit(BookmarkFailure(message: failure.message)),
      (newBookmark) {
        if (state is BookmarkSuccess) {
          final current = state as BookmarkSuccess;
          emit(
            current.copyWith(
              bookmarks: [newBookmark, ...current.bookmarks],
            ),
          );
        } else {
          // if we weren’t already in a success state, just reload
          loadBookmarks(isRefresh: true);
        }
      },
    );
  }

  /// 3) Delete a bookmark, then remove it from the current list
  Future<void> removeBookmark(String bookmarkId) async {
    if (state is! BookmarkSuccess) return;
    final current = state as BookmarkSuccess;
    final user = await SecureStorageService.getCurrentUser();

    // Optimistic update
    final updatedList =
        current.bookmarks.where((b) => b.id != bookmarkId).toList();
    emit(current.copyWith(bookmarks: updatedList));

    final Either<Failure, void> result =
        await bookmarkRepo.deleteBookmark(bookmarkId, user!.token);

    result.fold(
      (failure) {
        // Revert on failure
        emit(BookmarkFailure(message: failure.message));
        // Optionally reload full list:
        loadBookmarks(isRefresh: true);
      },
      (_) {
        // no-op: we already removed it optimistically
      },
    );
  }
}

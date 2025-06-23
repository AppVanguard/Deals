import 'dart:developer';

import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:deals/core/manager/cubit/requires_user_mixin.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmark_repo.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_pagination_entity.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends SafeCubit<BookmarkState> with RequiresUser<BookmarkState> {
  final BookmarkRepo _repo;

  BookmarkCubit({required BookmarkRepo repo})
      : _repo = repo,
        super(BookmarkInitial()) {
    loadBookmarks(isRefresh: true);
  }

  //──────────────────── internal filters
  int _page = 1;
  final int _limit = 5;

  String _search = '';
  List<String> _catIds = [];
  bool _hasCoupons = false;
  bool _hasCashback = false;
  String _sortOrder = 'asc';
  //──────────────────────────────────────

  /*════════════════════ public api ════════════════════*/

  Future<void> loadBookmarks({bool isRefresh = false}) async {
    log('[BookmarkCubit] loadBookmarks() — page=$_page refresh=$isRefresh');

    if (isRefresh) _page = 1;

    if (state is BookmarkSuccess && !isRefresh) {
      final s = state as BookmarkSuccess;
      if (s.pagination.currentPage >= s.pagination.totalPages) {
        log('[BookmarkCubit] reached last page, aborting load');
        return;
      }
      emit(s.copyWith(isLoadingMore: true));
    } else {
      emit(BookmarkLoading());
    }

    try {
      final user =
          await requireUser((msg) => BookmarkFailure(message: msg));
      if (user == null) return;

      final res = await _repo.getUserBookmarks(
        firebaseUid: user.uId,
        token: user.token,
        page: _page,
        limit: _limit,
        search: _search,
        categories: _catIds,
        hasCoupons: _hasCoupons,
        hasCashback: _hasCashback,
        sortOrder: _sortOrder,
      );

      res.fold(
        (Failure f) {
          log('[BookmarkCubit] loadBookmarks failure: ${f.message}');
          emit(BookmarkFailure(message: f.message));
        },
        (success) {
          log('[BookmarkCubit] loadBookmarks success '
              'items=${success.bookmarks.length} '
              'page=${success.pagination.currentPage}/${success.pagination.totalPages}');

          final merged = _mergeList(
            newItems: success.bookmarks,
            isRefresh: isRefresh,
          );

          emit(BookmarkSuccess(
            bookmarks: merged,
            pagination: success.pagination,
          ));

          if (success.pagination.currentPage < success.pagination.totalPages) {
            _page++;
          }
        },
      );
    } catch (e, st) {
      log('[BookmarkCubit] loadBookmarks exception', error: e, stackTrace: st);
      emit(BookmarkFailure(message: e.toString()));
    }
  }

  Future<void> loadNextPage() => loadBookmarks();

  void updateFilters({
    String? search,
    List<String>? categories,
    bool? hasCoupons,
    bool? hasCashback,
    String? sortOrder,
  }) {
    _search = search ?? _search;
    _catIds = categories ?? _catIds;
    _hasCoupons = hasCoupons ?? _hasCoupons;
    _hasCashback = hasCashback ?? _hasCashback;
    _sortOrder = sortOrder ?? _sortOrder;

    log('[BookmarkCubit] updateFilters '
        'search=$_search catIds=$_catIds coupons=$_hasCoupons cashback=$_hasCashback sort=$_sortOrder');

    loadBookmarks(isRefresh: true);
  }

  /*══════════ bookmark-specific helpers ══════════*/

  bool isBookmarked(String storeId) {
    if (state is! BookmarkSuccess) return false;
    return (state as BookmarkSuccess)
        .bookmarks
        .any((b) => b.storeId == storeId);
  }

  Future<void> toggleBookmark(String storeId) async {
    if (state is! BookmarkSuccess) return;

    log('[BookmarkCubit] toggleBookmark store=$storeId '
        'currentlySaved=${isBookmarked(storeId)}');

    if (isBookmarked(storeId)) {
      final existing =
          (state as BookmarkSuccess).bookmarks.firstWhere((b) => b.storeId == storeId);
      await _removeBookmark(existing.id);
    } else {
      await _addBookmark(storeId);
    }
  }

  /*────────── internal add & remove ──────────*/

  Future<void> _addBookmark(String storeId) async {
    final user = await requireUser((msg) => BookmarkFailure(message: msg));
    if (user == null) return;

    log('[BookmarkCubit] _addBookmark POST store=$storeId');

    final res = await _repo.createBookmark(
      firebaseUid: user.uId,
      storeId: storeId,
      token: user.token,
    );

    res.fold(
      (f) => log('[BookmarkCubit] _addBookmark failed: ${f.message}'),
      (_) => log('[BookmarkCubit] _addBookmark success'),
    );

    // Refresh list to get full bookmark object
    await loadBookmarks(isRefresh: true);
  }

  Future<void> _removeBookmark(String bookmarkId) async {
    final user = await requireUser((msg) => BookmarkFailure(message: msg));
    if (user == null) return;

    log('[BookmarkCubit] _removeBookmark DELETE id=$bookmarkId');

    final res = await _repo.deleteBookmark(
      bookmarkId: bookmarkId,
      token: user.token,
    );

    res.fold(
      (f) => log('[BookmarkCubit] _removeBookmark failed: ${f.message}'),
      (_) => log('[BookmarkCubit] _removeBookmark success'),
    );

    await loadBookmarks(isRefresh: true);
  }

  /*─────────────── merge helper ───────────────*/
  List<BookmarkEntity> _mergeList({
    required List<BookmarkEntity> newItems,
    required bool isRefresh,
  }) {
    if (isRefresh || state is! BookmarkSuccess) return newItems;
    final s = state as BookmarkSuccess;
    return List.of(s.bookmarks)..addAll(newItems);
  }
}

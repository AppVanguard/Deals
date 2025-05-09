import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmark_repo.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_pagination_entity.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepo _repo;

  BookmarkCubit({required BookmarkRepo repo})
      : _repo = repo,
        super(BookmarkInitial()) {
    loadBookmarks(isRefresh: true);
  }

  // filters
  int _page = 1;
  final int _limit = 5;

  String _search = '';
  List<String> _catIds = [];
  bool _hasCoupons = false;
  bool _hasCashback = false;
  String _sortOrder = 'asc';

  /*══════════════════════  API  ══════════════════════*/
  Future<void> loadBookmarks({bool isRefresh = false}) async {
    if (isRefresh) _page = 1;

    // manage loading states
    if (state is BookmarkSuccess && !isRefresh) {
      final s = state as BookmarkSuccess;
      if (s.pagination.currentPage >= s.pagination.totalPages) return;
      emit(s.copyWith(isLoadingMore: true));
    } else {
      emit(BookmarkLoading());
    }

    try {
      final user = await SecureStorageService.getCurrentUser();
      if (user == null) {
        emit(BookmarkFailure(message: 'user not found'));
        return;
      }

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
        (Failure f) => emit(BookmarkFailure(message: f.message)),
        (success) {
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
    } catch (e) {
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

    loadBookmarks(isRefresh: true);
  }

  /* helpers */
  List<BookmarkEntity> _mergeList({
    required List<BookmarkEntity> newItems,
    required bool isRefresh,
  }) {
    if (isRefresh || state is! BookmarkSuccess) return newItems;
    final s = state as BookmarkSuccess;
    return List.of(s.bookmarks)..addAll(newItems);
  }
}

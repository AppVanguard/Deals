import 'package:deals/core/manager/cubit/requires_user_mixin.dart';
import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';

part 'stores_state.dart';

class StoresCubit extends SafeCubit<StoresState> with RequiresUser<StoresState> {
  final StoresRepo storesRepo;

  // Internal parameters for filtering, sorting, and pagination.
  int _currentPage = 1;
  String? _search;
  String _sortField = 'title';
  String _sortOrder = 'asc';
  int _limit = 10;
  String? _categoryId;

  StoresCubit({required this.storesRepo}) : super(StoresInitial()) {
    loadStores(isRefresh: true);
  }

  /// Loads stores data.
  /// If [isRefresh] is true, pagination resets to the first page.
  Future<void> loadStores({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
    }
    final user = await requireUser((msg) => StoresFailure(message: msg));
    if (user == null) return;

    // When appending data (load more) check if the current state is a success.
    if (state is StoresSuccess && !isRefresh) {
      final currentState = state as StoresSuccess;
      // If there is no next page, return early.
      if (!currentState.pagination.hasNextPage) return;
      // Emit a state indicating that additional data is loading.
      emit(StoresSuccess(
        stores: currentState.stores,
        pagination: currentState.pagination,
        isLoadingMore: true,
      ));
    } else {
      emit(StoresLoading());
    }

    try {
      final result = await storesRepo.getAllStores(
        search: _search,
        sortField: _sortField,
        page: _currentPage,
        limit: _limit,
        sortOrder: _sortOrder,
        categoryId: _categoryId,
        token: user!.token,
      );

      result.fold(
        (failure) => emit(StoresFailure(message: failure.message)),
        (storesWithPagination) {
          List<StoreEntity> updatedStores = [];
          if (isRefresh || state is! StoresSuccess) {
            // Use fresh data when refreshing or on initial load.
            updatedStores = storesWithPagination.stores;
          } else if (state is StoresSuccess) {
            // Append new stores to the existing list.
            final currentState = state as StoresSuccess;
            updatedStores = List.from(currentState.stores)
              ..addAll(storesWithPagination.stores);
          }

          emit(StoresSuccess(
            stores: updatedStores,
            pagination: storesWithPagination.pagination,
          ));

          // If more pages are available, update the current page.
          if (storesWithPagination.pagination.hasNextPage) {
            _currentPage++;
          }
        },
      );
    } catch (e) {
      emit(StoresFailure(message: e.toString()));
    }
  }

  /// Updates filtering, sorting, and pagination parameters,
  /// then reloads the stores data.
  void updateFilters({
    String? search,
    String? sortField,
    String? sortOrder,
    int? limit,
    String? categoryId,
  }) {
    _search = search;
    if (sortField != null) _sortField = sortField;
    if (sortOrder != null) _sortOrder = sortOrder;
    if (limit != null) _limit = limit;
    _categoryId = categoryId;

    _currentPage = 1;
    loadStores(isRefresh: true);
  }

  /// Loads the next page if available.
  Future<void> loadNextPage() async {
    if (state is StoresSuccess) {
      final currentState = state as StoresSuccess;
      if (currentState.pagination.hasNextPage) {
        await loadStores();
      }
    }
  }
}

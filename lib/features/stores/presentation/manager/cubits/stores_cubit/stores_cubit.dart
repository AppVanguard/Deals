import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';

part 'stores_state.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoresRepo storesRepo;

  // Internal parameters for filtering, sorting, and pagination.
  int _currentPage = 1;
  String? _search;
  String _sortField = 'title';
  String _sortOrder = 'asc';
  int _limit = 10;
  String? _categoryId;

  StoresCubit({required this.storesRepo}) : super(StoresInitial()) {
    // Optionally load a list of stores at initialization:
    loadStores(isRefresh: true);
  }

  /// Loads stores data (multiple stores).
  /// If [isRefresh] is true, pagination resets to the first page.
  Future<void> loadStores({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
    }

    // If we're appending (not refresh) and we already have a success state:
    if (state is StoresSuccess && !isRefresh) {
      final currentState = state as StoresSuccess;
      // If there's no next page, nothing to load:
      if (!currentState.pagination.hasNextPage) return;
      // Otherwise, emit a success state showing a "load more" in progress.
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
      );

      result.fold(
        (failure) => emit(StoresFailure(message: failure.message)),
        (storesWithPagination) {
          List<StoreEntity> updatedStores = [];
          if (isRefresh || state is! StoresSuccess) {
            // Use fresh data if it's the first load or a forced refresh.
            updatedStores = storesWithPagination.stores;
          } else {
            // Append new data to the existing list.
            final currentState = state as StoresSuccess;
            updatedStores = List.from(currentState.stores)
              ..addAll(storesWithPagination.stores);
          }

          emit(StoresSuccess(
            stores: updatedStores,
            pagination: storesWithPagination.pagination,
          ));

          // If there's another page, increment so we can load next time.
          if (storesWithPagination.pagination.hasNextPage) {
            _currentPage++;
          }
        },
      );
    } catch (e) {
      emit(StoresFailure(message: e.toString()));
    }
  }

  /// Retrieves a single store by its [storeId].
  /// Emits [SingleStoreLoading] => [SingleStoreSuccess] or [SingleStoreFailure].
  Future<void> getStoreById(String storeId) async {
    emit(SingleStoreLoading());
    final result = await storesRepo.getStoreById(storeId);
    result.fold(
      (failure) => emit(SingleStoreFailure(message: failure.message)),
      (storeEntity) => emit(SingleStoreSuccess(store: storeEntity)),
    );
  }

  /// Updates filtering, sorting, and pagination parameters,
  /// then reloads the stores data (starting from the first page).
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

    // Reset to first page whenever filters change.
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

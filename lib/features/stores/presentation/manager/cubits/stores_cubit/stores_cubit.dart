// stores_cubit.dart

import 'package:deals/core/entities/pagination_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';

part 'stores_state.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoresRepo storesRepo;

  // Tracking pagination locally
  int currentPage = 1;
  int limit = 10;
  String? search;
  String? sortField;
  String? sortOrder;

  StoresCubit({required this.storesRepo}) : super(StoresInitial()) {
    // Immediately fetch on creation
    fetchStores(isRefresh: true);
  }

  Future<void> fetchStores({
    bool isRefresh = false,
    String? search,
    String? sortField,
    String? sortOrder,
    int? limit,
  }) async {
    // Update optional query params
    if (search != null) this.search = search;
    if (sortField != null) this.sortField = sortField;
    if (sortOrder != null) this.sortOrder = sortOrder;
    if (limit != null) this.limit = limit;

    if (isRefresh) {
      // Full reload
      currentPage = 1;
      emit(StoresLoading());
    } else {
      // Loading next page
      if (state is StoresSuccess) {
        final successState = state as StoresSuccess;
        // If no more pages, do nothing
        if (!successState.pagination.hasNextPage) {
          return;
        }
        // Otherwise, set partial loading
        emit(successState.copyWith(isLoadingMore: true));
      } else {
        // If not in success yet, just show a full load
        emit(StoresLoading());
      }
    }

    try {
      final eitherResult = await storesRepo.getAllStores(
        search: this.search,
        sortField: this.sortField,
        sortOrder: this.sortOrder,
        page: currentPage,
        limit: this.limit,
      );

      eitherResult.fold(
        (failure) {
          emit(StoresFailure(message: failure.message));
        },
        (storesWithPagination) {
          final newStores = storesWithPagination.stores;
          final newPagination = storesWithPagination.pagination;

          if (isRefresh || state is! StoresSuccess) {
            // Replace entire list
            emit(
              StoresSuccess(
                stores: newStores,
                pagination: newPagination,
                isLoadingMore: false,
              ),
            );
          } else {
            // Append to existing
            final oldState = state as StoresSuccess;
            final updatedStores = List<StoreEntity>.from(oldState.stores)
              ..addAll(newStores);

            emit(
              oldState.copyWith(
                stores: updatedStores,
                pagination: newPagination,
                isLoadingMore: false,
              ),
            );
          }

          // Only increment local page if there's a next page
          if (newPagination.hasNextPage) {
            currentPage++;
          }
        },
      );
    } catch (e) {
      emit(StoresFailure(message: e.toString()));
    }
  }
}

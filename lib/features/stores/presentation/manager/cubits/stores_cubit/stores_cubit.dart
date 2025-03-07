import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'stores_state.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoresRepo storesRepo;

  // Pagination + query params
  int currentPage = 1;
  bool hasMore = true;

  String? search;
  String? sortField;
  String? sortOrder;
  int limit = 10;

  /// Immediately fetch data in the constructor so we don't stay in `StoresInitial`.
  /// This ensures we emit `StoresLoading` -> the UI can show skeletons right away.
  StoresCubit({required this.storesRepo}) : super(StoresInitial()) {
    fetchStores(isRefresh: true);
  }

  /// Fetch the stores data.
  /// [isRefresh] = true => full reload
  /// [isRefresh] = false => load next page
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
      hasMore = true;
      emit(StoresLoading());
    } else {
      // Attempt to load more (pagination)
      if (state is StoresSuccess) {
        final oldState = state as StoresSuccess;
        if (!oldState.hasMore) {
          // No more data => do nothing
          return;
        }
        // Keep the existing items, but set isLoadingMore=true
        emit(oldState.copyWith(isLoadingMore: true));
      } else {
        // If not in success state yet, fallback to full load
        emit(StoresLoading());
      }
    }

    try {
      // Retrieve new data from the repository
      final eitherResult = await storesRepo.getAllStores(
        search: this.search,
        sortField: this.sortField,
        sortOrder: this.sortOrder,
        page: currentPage,
        limit: this.limit,
      );

      eitherResult.fold(
        // On failure
        (failure) => emit(StoresFailure(message: failure.message)),

        // On success
        (newStores) {
          // If fewer items returned than 'limit', no more pages
          if (newStores.length < this.limit) {
            hasMore = false;
          } else {
            hasMore = true;
          }

          // If refreshing or haven't had success yet, replace list entirely
          if (isRefresh || state is! StoresSuccess) {
            emit(StoresSuccess(
              stores: newStores,
              currentPage: currentPage,
              hasMore: hasMore,
              isLoadingMore: false,
            ));
          } else {
            // Append new data
            final oldState = state as StoresSuccess;
            final updatedStores = List<StoreEntity>.from(oldState.stores)
              ..addAll(newStores);

            emit(oldState.copyWith(
              stores: updatedStores,
              currentPage: currentPage,
              hasMore: hasMore,
              isLoadingMore: false,
            ));
          }

          currentPage++;
        },
      );
    } catch (e) {
      emit(StoresFailure(message: e.toString()));
    }
  }
}

import 'package:deals/core/entities/store_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';

part 'stores_state.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoresRepo storesRepo;

  // Track pagination and query parameters:
  int currentPage = 1;
  bool hasMore = true;
  String? search;
  String? sortField;
  String? sortOrder;
  int limit = 10;

  StoresCubit({required this.storesRepo}) : super(StoresInitial());

  /// Fetch the stores data.
  /// [isRefresh] = true means start from page 1 and replace old data.
  Future<void> fetchStores({
    bool isRefresh = false,
    String? search,
    String? sortField,
    String? sortOrder,
    int? limit,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      emit(StoresLoading());
    }

    // Update query parameters if provided.
    if (search != null) this.search = search;
    if (sortField != null) this.sortField = sortField;
    if (sortOrder != null) this.sortOrder = sortOrder;
    if (limit != null) this.limit = limit;

    // If not a refresh and no more data is available, do nothing.
    if (!isRefresh &&
        state is StoresSuccess &&
        !(state as StoresSuccess).hasMore) {
      return;
    }

    try {
      // Get the list of StoreEntity from the repository.
      final eitherResult = await storesRepo.getAllStores(
        search: this.search,
        sortField: this.sortField,
        sortOrder: this.sortOrder,
        page: currentPage,
        limit: this.limit,
      );

      eitherResult.fold((failure) {
        emit(StoresFailure(message: failure.message));
      }, (newStores) {
        // Determine if there are more pages.
        // If the returned list is empty or its length is less than limit, then no more data.
        if (newStores.isEmpty || newStores.length < this.limit) {
          hasMore = false;
        } else {
          hasMore = true;
        }

        if (isRefresh || state is! StoresSuccess) {
          // Replace the list entirely.
          emit(StoresSuccess(
            stores: newStores,
            currentPage: currentPage,
            hasMore: hasMore,
          ));
        } else {
          // Append new items to the existing list.
          final oldState = state as StoresSuccess;
          final updatedStores = List<StoreEntity>.from(oldState.stores)
            ..addAll(newStores);
          emit(StoresSuccess(
            stores: updatedStores,
            currentPage: currentPage,
            hasMore: hasMore,
          ));
        }
        // Prepare for next page.
        currentPage++;
      });
    } catch (e) {
      emit(StoresFailure(message: e.toString()));
    }
  }
}

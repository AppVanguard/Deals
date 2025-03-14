part of 'stores_cubit.dart';

@immutable
abstract class StoresState {}

/// Initial state (e.g. before any loading)
class StoresInitial extends StoresState {}

/// Generic "loading" state for the main list.
class StoresLoading extends StoresState {}

/// Holds a list of stores and pagination data (e.g. after a successful fetch).
class StoresSuccess extends StoresState {
  final List<StoreEntity> stores;
  final PaginationEntity pagination;
  final bool isLoadingMore;

  StoresSuccess({
    required this.stores,
    required this.pagination,
    this.isLoadingMore = false,
  });

  StoresSuccess copyWith({
    List<StoreEntity>? stores,
    PaginationEntity? pagination,
    bool? isLoadingMore,
  }) {
    return StoresSuccess(
      stores: stores ?? this.stores,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Represents a failure when fetching the main list of stores.
class StoresFailure extends StoresState {
  final String message;
  StoresFailure({required this.message});
}

// ---------------------------------------------------------------------
// Single-store states
// ---------------------------------------------------------------------

/// Single store loading state (e.g. when fetching details by ID)
class SingleStoreLoading extends StoresState {}

/// Single store success state, holds the fetched [StoreEntity].
class SingleStoreSuccess extends StoresState {
  final StoreEntity store;
  SingleStoreSuccess({required this.store});
}

/// Single store failure state, holds the error [message].
class SingleStoreFailure extends StoresState {
  final String message;
  SingleStoreFailure({required this.message});
}

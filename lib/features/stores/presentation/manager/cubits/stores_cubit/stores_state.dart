part of 'stores_cubit.dart';

@immutable
abstract class StoresState {}

class StoresInitial extends StoresState {}

class StoresLoading extends StoresState {}

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

class StoresFailure extends StoresState {
  final String message;
  StoresFailure({required this.message});
}

// -----------------------------------------------------
// NEW: single store states
// -----------------------------------------------------
class SingleStoreLoading extends StoresState {}

class SingleStoreSuccess extends StoresState {
  final StoreEntity store;
  SingleStoreSuccess(this.store);
}

class SingleStoreFailure extends StoresState {
  final String message;
  SingleStoreFailure({required this.message});
}

part of 'stores_cubit.dart';

@immutable
abstract class StoresState {}

/// Initial = no data yet
class StoresInitial extends StoresState {}

/// Full refresh or first load
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

/// Failure
class StoresFailure extends StoresState {
  final String message;
  StoresFailure({required this.message});
}

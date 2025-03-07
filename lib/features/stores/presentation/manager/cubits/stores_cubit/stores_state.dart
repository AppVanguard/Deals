part of 'stores_cubit.dart';

@immutable
abstract class StoresState {}

/// Initial = no data yet, waiting to fetch
class StoresInitial extends StoresState {}

/// Full refresh or first load
class StoresLoading extends StoresState {}

/// Success with the loaded store list
/// Also includes a flag for partial loading (isLoadingMore)
class StoresSuccess extends StoresState {
  final List<StoreEntity> stores;
  final int currentPage;
  final bool hasMore;

  /// True if we're currently fetching more data (pagination),
  /// so we can show partial skeleton placeholders at the bottom.
  final bool isLoadingMore;

  StoresSuccess({
    required this.stores,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  /// Helper for updating this state while retaining old fields
  StoresSuccess copyWith({
    List<StoreEntity>? stores,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return StoresSuccess(
      stores: stores ?? this.stores,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Failure with an error message
class StoresFailure extends StoresState {
  final String message;
  StoresFailure({required this.message});
}

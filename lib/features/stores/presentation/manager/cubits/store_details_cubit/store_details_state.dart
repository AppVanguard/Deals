part of 'store_details_cubit.dart';

@immutable
abstract class StoreDetailsState {}

/// Initial state (before any store detail is requested)
class StoreDetailsInitial extends StoreDetailsState {}

/// Loading state while retrieving store details and coupons
class StoreDetailsLoading extends StoreDetailsState {}

/// Success state that holds the store details and its coupons
class StoreDetailsSuccess extends StoreDetailsState {
  final StoreEntity store;
  final List<CouponEntity> coupons;
  final PaginationEntity pagination;
  final bool isLoadingMore;

  StoreDetailsSuccess({
    required this.store,
    required this.coupons,
    required this.pagination,
    this.isLoadingMore = false,
  });

  StoreDetailsSuccess copyWith({
    List<CouponEntity>? coupons,
    PaginationEntity? pagination,
    bool? isLoadingMore,
  }) {
    return StoreDetailsSuccess(
      store: store,
      coupons: coupons ?? this.coupons,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Failure state with an error [message]
class StoreDetailsFailure extends StoreDetailsState {
  final String message;

  StoreDetailsFailure({required this.message});
}

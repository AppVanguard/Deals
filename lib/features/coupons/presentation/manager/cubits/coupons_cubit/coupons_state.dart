part of 'coupons_cubit.dart';

@immutable
abstract class CouponsState {}

class CouponsInitial extends CouponsState {}

class CouponsLoading extends CouponsState {}

class CouponsSuccess extends CouponsState {
  final List<CouponEntity> coupons;
  final PaginationEntity pagination;
  final bool isLoadingMore;

  CouponsSuccess({
    required this.coupons,
    required this.pagination,
    this.isLoadingMore = false,
  });

  CouponsSuccess copyWith({
    List<CouponEntity>? coupons,
    PaginationEntity? pagination,
    bool? isLoadingMore,
  }) {
    return CouponsSuccess(
      coupons: coupons ?? this.coupons,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CouponsFailure extends CouponsState {
  final String message;
  CouponsFailure({required this.message});
}

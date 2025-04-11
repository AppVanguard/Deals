part of 'coupon_detail_cubit.dart';

@immutable
abstract class CouponDetailState {}

/// The initial state before any coupon detail is requested.
class CouponDetailInitial extends CouponDetailState {}

/// Loading state while the coupon detail is being fetched.
class CouponDetailLoading extends CouponDetailState {}

/// Success state containing the fetched coupon details.
class CouponDetailSuccess extends CouponDetailState {
  final CouponEntity coupon;

  CouponDetailSuccess({required this.coupon});
}

/// Failure state with an error [message].
class CouponDetailFailure extends CouponDetailState {
  final String message;

  CouponDetailFailure({required this.message});
}

import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/coupons/domain/repos/coupons_with_pagination.dart';

abstract class CouponsRepo {
  Future<Either<Failure, CouponsWithPaginationEntity>> getAllCoupons({
    String? search,
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
    String? category,
    String? discountType,
    String? storeId,
  });

  Future<Either<Failure, CouponEntity>> getCouponById(String id);
}

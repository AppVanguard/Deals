import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/pagination_entity.dart';

class CouponsWithPaginationEntity {
  final List<CouponEntity> coupons;
  final PaginationEntity pagination;

  CouponsWithPaginationEntity({
    required this.coupons,
    required this.pagination,
  });
}

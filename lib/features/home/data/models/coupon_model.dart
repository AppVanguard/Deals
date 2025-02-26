import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    required super.id,
    required super.code,
    required super.title,
    required super.isActive,
    required super.status,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      isActive: json['is_active'] ?? false,
      status: json['status'] ?? '',
    );
  }
}

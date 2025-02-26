import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/data/models/announcement_model.dart';
import 'package:in_pocket/features/home/data/models/store_model.dart';
import 'package:in_pocket/features/home/data/models/coupon_model.dart';

class HomeModel extends HomeEntity {
  const HomeModel({
    required List<AnnouncementModel> announcements,
    required List<StoreModel> stores,
    required List<CouponModel> coupons,
  }) : super(
          announcements: announcements,
          stores: stores,
          coupons: coupons,
        );

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      announcements: (json['announcements'] as List<dynamic>?)
              ?.map((ann) =>
                  AnnouncementModel.fromJson(ann as Map<String, dynamic>))
              .toList() ??
          [],
      stores: (json['stores'] as List<dynamic>?)
              ?.map(
                  (store) => StoreModel.fromJson(store as Map<String, dynamic>))
              .toList() ??
          [],
      coupons: (json['coupons'] as List<dynamic>?)
              ?.map((coupon) =>
                  CouponModel.fromJson(coupon as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

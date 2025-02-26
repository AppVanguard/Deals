// home_entity.dart
import 'package:in_pocket/features/home/domain/entities/announcement_entity.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';
import 'package:in_pocket/features/home/domain/entities/store_entity.dart';

class HomeEntity {
  final List<AnnouncementEntity> announcements;
  final List<StoreEntity> stores;
  final List<CouponEntity> coupons;

  const HomeEntity({
    required this.announcements,
    required this.stores,
    required this.coupons,
  });
}

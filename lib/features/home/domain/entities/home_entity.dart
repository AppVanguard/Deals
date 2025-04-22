import 'package:deals/core/entities/announcement_entity.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/store_entity.dart';

class HomeEntity {
  final List<AnnouncementEntity> announcements;
  final List<StoreEntity> stores;
  final List<CouponEntity> coupons;

  // Typically, keep them unmodifiable.
  // But if you prefer, you can allow them to be modifiable.
  const HomeEntity({
    required this.announcements,
    required this.stores,
    required this.coupons,
  });
}

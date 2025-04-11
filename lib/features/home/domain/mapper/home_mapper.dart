// home_mapper.dart
import 'dart:developer';

import 'package:deals/features/home/data/models/home_model/announcement.dart';
import 'package:deals/features/home/data/models/home_model/coupon.dart';
import 'package:deals/core/entities/announcement_entity.dart';
import 'package:deals/features/home/data/models/home_model/home_model.dart';
import 'package:deals/features/home/data/models/home_model/store.dart';
import 'package:deals/features/home/domain/entities/home_entity.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/entities/coupon_entity.dart';

class HomeMapper {
  static HomeEntity mapToEntity(HomeModel model) {
    return HomeEntity(
      // If you have actual announcements in domain,
      // you can map them here. Or keep them empty if not used.
      announcements: model.announcements == null
          ? []
          : model.announcements!.map((a) => _mapAnnouncement(a)).toList(),

      stores: model.stores == null
          ? []
          : model.stores!.map((s) => _mapStore(s)).toList(),

      coupons: model.coupons == null
          ? []
          : model.coupons!.map((c) => _mapCoupon(c)).toList(),
    );
  }

  static AnnouncementEntity _mapAnnouncement(Announcement announcementModel) {
    return AnnouncementEntity(
      id: announcementModel.id ?? '',
      title: announcementModel.title ?? '',
      description: announcementModel.description ?? '',
      isActive: announcementModel.isActive ?? false,
      createdAt: announcementModel.createdAt,
      updatedAt: announcementModel.updatedAt,
      imageUrl: announcementModel.image?.url,
      deletedAt: announcementModel.deletedAt,
    );
  }

  static StoreEntity _mapStore(Store storeModel) {
    return StoreEntity(
      id: storeModel.id ?? '',
      title: storeModel.title ?? '',
      activeCoupons: storeModel.activeCoupons ?? 0,
      imageUrl: storeModel.image?.url,
      cashBackRate: storeModel.cashback?.rate ?? 0,
      categoryId: storeModel.category ?? '',
      isActive: storeModel.isActive ?? false,
      popularityScore: storeModel.popularityScore ?? 0,
      storeUrl: storeModel.storeUrl ?? '',
      totalCoupons: storeModel.totalCoupons ?? 0,
    );
  }

  static CouponEntity _mapCoupon(Coupon couponModel) {
    log('Mapping coupon: $couponModel');
    return CouponEntity(
      id: couponModel.id ?? '',
      code: couponModel.code ?? '',
      title: couponModel.title ?? '',
      startDate: couponModel.startDate,
      expiryDate: couponModel.expiryDate,
      discountValue: couponModel.discountValue ?? 0,
      image: couponModel.store?.image?.url,
    );
  }
}

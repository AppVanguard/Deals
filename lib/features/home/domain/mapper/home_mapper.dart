// home_mapper.dart
import 'dart:developer';

import 'package:deals/features/home/data/models/announcement.dart';
import 'package:deals/features/home/data/models/home_model.dart';
import 'package:deals/features/home/data/models/store.dart';
import 'package:deals/features/home/data/models/coupon.dart';
import 'package:deals/core/entities/announcement_entity.dart';
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
      imageUrl: null,
      createdAt: announcementModel.createdAt ?? '',
      updatedAt: announcementModel.updatedAt ?? '',
      deletedAt: announcementModel.deletedAt,
    );
  }

  static StoreEntity _mapStore(Store storeModel) {
    return StoreEntity(
      category: null,
      id: storeModel.id ?? '',
      title: storeModel.title ?? '',
      storeUrl: storeModel.storeUrl ?? '',
      imageUrl: storeModel.image?.url,
      // etc. whichever fields you need in domain
      isActive: storeModel.isActive ?? false,
    );
  }

  static CouponEntity _mapCoupon(Coupon couponModel) {
    log('Mapping coupon: $couponModel');
    return CouponEntity(
      validForExisting: couponModel.validFor?.existingCustomers ?? false,
      validForNew: couponModel.validFor?.newCustomers ?? false,
      id: couponModel.id ?? '',
      code: couponModel.code ?? '',
      title: couponModel.title ?? '',
      startDate: couponModel.startDate,
      expiryDate: couponModel.expiryDate,
      isActive: couponModel.isActive ?? false,
      discountValue: couponModel.discountValue ?? 0,
    );
  }
}

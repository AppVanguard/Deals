// home_repo_impl.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/core/service/home_api_service.dart';
import 'package:in_pocket/features/home/data/models/coupon.dart';
import 'package:in_pocket/features/home/data/models/home_model.dart';
import 'package:in_pocket/features/home/data/models/store.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/domain/entities/store_entity.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';
import 'package:in_pocket/features/home/domain/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeService homeService;

  HomeRepoImpl({required this.homeService});

  @override
  Future<Either<Failure, HomeEntity>> getHomeData({
    required int announcementsPage,
    required int announcementsCount,
    required int storesPage,
    required int storesCount,
    required int couponsPage,
    required int couponsCount,
  }) async {
    try {
      // 1) Get the Data-layer model
      final HomeModel homeModel = await homeService.getHomeData(
        announcementsPage: announcementsPage,
        announcementsCount: announcementsCount,
        storesPage: storesPage,
        storesCount: storesCount,
        couponsPage: couponsPage,
        couponsCount: couponsCount,
      );

      // 2) Map Data -> Domain
      final HomeEntity homeEntity = _mapHomeModelToEntity(homeModel);

      // 3) Return success
      return Right(homeEntity);
    } catch (e) {
      log('Error in HomeRepoImpl.getHomeData: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  // Helper to map from HomeModel (Data) to HomeEntity (Domain)
  HomeEntity _mapHomeModelToEntity(HomeModel model) {
    return HomeEntity(
      // If you have an AnnouncementEntity, map them. Otherwise, empty
      announcements: const [],
      // map stores
      stores: model.stores == null
          ? []
          : model.stores!.map((store) => _mapStoreToEntity(store)).toList(),
      // map coupons
      coupons: model.coupons == null
          ? []
          : model.coupons!.map((coupon) => _mapCouponToEntity(coupon)).toList(),
    );
  }

  StoreEntity _mapStoreToEntity(Store storeModel) {
    return StoreEntity(
      id: storeModel.id ?? '',
      title: storeModel.title ?? '',
      storeUrl: storeModel.storeUrl ?? '',
      imageUrl: storeModel.image?.url, // if you want the store's image
      isActive: storeModel.isActive ?? false,
      // add other fields if your domain entity has them
    );
  }

  CouponEntity _mapCouponToEntity(Coupon couponModel) {
    return CouponEntity(
      validForExisting: couponModel.validFor?.existingCustomers ?? false,
      validForNew: couponModel.validFor?.newCustomers ?? false,
      id: couponModel.id ?? '',
      code: couponModel.code ?? '',
      title: couponModel.title ?? '',
      // keep them as DateTime in domain
      startDate: couponModel.startDate,
      expiryDate: couponModel.expiryDate,
      isActive: couponModel.isActive ?? false,
    );
  }
}

import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/features/coupons/data/models/coupons_data.dart';
import 'package:deals/features/coupons/data/models/coupons_model.dart';

class CouponsMapper {
  static List<CouponEntity> mapToEntities(CouponsModel model) {
    return model.data == null
        ? []
        : model.data!.map((couponModel) => mapToEntity(couponModel)).toList();
  }

  static CouponEntity mapToEntity(CouponsData couponModel) {
    return CouponEntity(
      id: couponModel.id ?? '',
      code: couponModel.code ?? '',
      title: couponModel.title ?? '',
      discountValue: couponModel.discountValue ?? 0,
      expiryDate: couponModel.expiryDate,
      startDate: couponModel.startDate,
      image: couponModel.store?.image?.url ?? '',
      storeUrl: couponModel.store?.storeUrl,
      termsAndConditions: couponModel.termsAndConditions ?? [],
      description: couponModel.description ?? '',
      cashBak: couponModel.store?.cashback?.rate ?? 0,
      active: couponModel.status == "ACTIVE",
    );
  }
}

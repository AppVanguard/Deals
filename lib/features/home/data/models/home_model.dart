import 'coupon.dart';
import 'store.dart';

class HomeModel {
  List<dynamic>? announcements;
  List<Store>? stores;
  List<Coupon>? coupons;

  HomeModel({this.announcements, this.stores, this.coupons});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        announcements: json['announcements'] as List<dynamic>?,
        stores: (json['stores'] as List<dynamic>?)
            ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
            .toList(),
        coupons: (json['coupons'] as List<dynamic>?)
            ?.map((e) => Coupon.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'announcements': announcements,
        'stores': stores?.map((e) => e.toJson()).toList(),
        'coupons': coupons?.map((e) => e.toJson()).toList(),
      };
}

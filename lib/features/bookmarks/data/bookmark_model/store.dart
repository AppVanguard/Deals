import 'cashback.dart';
import 'image.dart';

class Store {
  String? id;
  String? title;
  Image? image;
  Cashback? cashback;
  int? totalCoupons;

  Store({
    this.id,
    this.title,
    this.image,
    this.cashback,
    this.totalCoupons,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        image: json['image'] == null
            ? null
            : Image.fromJson(json['image'] as Map<String, dynamic>),
        cashback: json['cashback'] == null
            ? null
            : Cashback.fromJson(json['cashback'] as Map<String, dynamic>),
        totalCoupons: json['total_coupons'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'image': image?.toJson(),
        'cashback': cashback?.toJson(),
        'total_coupons': totalCoupons,
      };
}

import 'store.dart';

class Coupon {
  String? id;
  String? code;
  Store? store;
  String? title;
  String? discountType;
  double? discountValue;
  DateTime? startDate;
  DateTime? expiryDate;
  DateTime? createdAt;
  String? description;

  Coupon({
    this.id,
    this.code,
    this.store,
    this.title,
    this.discountType,
    this.discountValue,
    this.startDate,
    this.expiryDate,
    this.createdAt,
    this.description,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json['_id'] as String?,
        code: json['code'] as String?,
        store: json['store'] == null
            ? null
            : Store.fromJson(json['store'] as Map<String, dynamic>),
        title: json['title'] as String?,
        discountType: json['discount_type'] as String?,
        discountValue: (json['discount_value'] as num?)?.toDouble(),
        startDate: json['start_date'] == null
            ? null
            : DateTime.parse(json['start_date'] as String),
        expiryDate: json['expiry_date'] == null
            ? null
            : DateTime.parse(json['expiry_date'] as String),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'code': code,
        'store': store?.toJson(),
        'title': title,
        'discount_type': discountType,
        'discount_value': discountValue,
        'start_date': startDate?.toIso8601String(),
        'expiry_date': expiryDate?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'description': description,
      };
}

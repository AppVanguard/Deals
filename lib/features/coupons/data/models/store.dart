import 'image.dart';
import 'cashback.dart';

class Store {
  String? id;
  String? title;
  Image? image;
  String? storeUrl;
  String? category;
  num? averageSavings;
  int? totalCoupons;
  int? activeCoupons;
  bool? isFeatured;
  bool? isActive;
  num? popularityScore;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? description;
  Cashback? cashback;

  Store({
    this.id,
    this.title,
    this.image,
    this.storeUrl,
    this.category,
    this.averageSavings,
    this.totalCoupons,
    this.activeCoupons,
    this.isFeatured,
    this.isActive,
    this.popularityScore,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.description,
    this.cashback,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        image: json['image'] == null
            ? null
            : Image.fromJson(json['image'] as Map<String, dynamic>),
        storeUrl: json['store_url'] as String?,
        category: json['category'] as String?,
        averageSavings: json['average_savings'] == null
            ? null
            : (json['average_savings'] as num).toInt(),
        totalCoupons: json['total_coupons'] == null
            ? null
            : (json['total_coupons'] as num).toInt(),
        activeCoupons: json['active_coupons'] == null
            ? null
            : (json['active_coupons'] as num).toInt(),
        isFeatured: json['is_featured'] as bool?,
        isActive: json['is_active'] as bool?,
        popularityScore: json['popularity_score'] == null
            ? null
            : (json['popularity_score'] as num).toInt(),
        deletedAt: json['deleted_at'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] == null ? null : (json['__v'] as num).toInt(),
        description: json['description'] as String?,
        cashback: json['cashback'] == null
            ? null
            : Cashback.fromJson(json['cashback'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'image': image?.toJson(),
        'store_url': storeUrl,
        'category': category,
        'average_savings': averageSavings,
        'total_coupons': totalCoupons,
        'active_coupons': activeCoupons,
        'is_featured': isFeatured,
        'is_active': isActive,
        'popularity_score': popularityScore,
        'deleted_at': deletedAt,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'description': description,
        'cashback': cashback?.toJson(),
      };
}

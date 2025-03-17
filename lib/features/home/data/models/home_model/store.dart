import 'cashback.dart';
import 'image.dart';

class Store {
  Image? image;
  Cashback? cashback;
  String? id;
  String? title;
  String? storeUrl;
  String? category;
  int? averageSavings;
  int? totalCoupons;
  int? activeCoupons;
  bool? isFeatured;
  bool? isActive;
  int? popularityScore;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? description;

  Store({
    this.image,
    this.cashback,
    this.id,
    this.title,
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
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        image: json['image'] == null
            ? null
            : Image.fromJson(json['image'] as Map<String, dynamic>),
        cashback: json['cashback'] == null
            ? null
            : Cashback.fromJson(json['cashback'] as Map<String, dynamic>),
        id: json['_id'] as String?,
        title: json['title'] as String?,
        storeUrl: json['store_url'] as String?,
        category: json['category'] as String?,
        averageSavings: json['average_savings'] as int?,
        totalCoupons: json['total_coupons'] as int?,
        activeCoupons: json['active_coupons'] as int?,
        isFeatured: json['is_featured'] as bool?,
        isActive: json['is_active'] as bool?,
        popularityScore: json['popularity_score'] as int?,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'image': image?.toJson(),
        'cashback': cashback?.toJson(),
        '_id': id,
        'title': title,
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
        'id': id,
      };
}

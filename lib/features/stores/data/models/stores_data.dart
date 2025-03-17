import 'cashback.dart';
import 'category.dart';
import 'image.dart';

class StoresData {
  String? id;
  String? title;
  Image? image;
  String? storeUrl;
  Category? category;
  Cashback? cashback;
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

  StoresData({
    this.id,
    this.title,
    this.image,
    this.storeUrl,
    this.category,
    this.cashback,
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

  factory StoresData.fromJson(Map<String, dynamic> json) => StoresData(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        image: json['image'] == null
            ? null
            : Image.fromJson(json['image'] as Map<String, dynamic>),
        storeUrl: json['store_url'] as String?,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
        cashback: json['cashback'] == null
            ? null
            : Cashback.fromJson(json['cashback'] as Map<String, dynamic>),
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
        '_id': id,
        'title': title,
        'image': image?.toJson(),
        'store_url': storeUrl,
        'category': category?.toJson(),
        'cashback': cashback?.toJson(),
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
      };
}

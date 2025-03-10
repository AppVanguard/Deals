class Category {
  String? id;
  String? title;
  String? colorCode;
  int? order;
  bool? isFeatured;
  int? storeCount;
  int? activeCouponCount;
  int? averageSavings;
  bool? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? slug;
  int? v;

  Category({
    this.id,
    this.title,
    this.colorCode,
    this.order,
    this.isFeatured,
    this.storeCount,
    this.activeCouponCount,
    this.averageSavings,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.slug,
    this.v,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        colorCode: json['color_code'] as String?,
        order: json['order'] as int?,
        isFeatured: json['is_featured'] as bool?,
        storeCount: json['store_count'] as int?,
        activeCouponCount: json['active_coupon_count'] as int?,
        averageSavings: json['average_savings'] as int?,
        isActive: json['is_active'] as bool?,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        slug: json['slug'] as String?,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'color_code': colorCode,
        'order': order,
        'is_featured': isFeatured,
        'store_count': storeCount,
        'active_coupon_count': activeCouponCount,
        'average_savings': averageSavings,
        'is_active': isActive,
        'deleted_at': deletedAt,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'slug': slug,
        '__v': v,
      };
}

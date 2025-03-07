class CategoryEntity {
  final String id;
  final String title;
  final String colorCode;
  final int order;
  final bool isFeatured;
  final int storeCount;
  final int activeCouponCount;
  final int averageSavings;
  final bool isActive;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String slug;

  CategoryEntity({
    required this.id,
    required this.title,
    required this.colorCode,
    required this.order,
    required this.isFeatured,
    required this.storeCount,
    required this.activeCouponCount,
    required this.averageSavings,
    required this.isActive,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
  });
}

class StoreEntity {
  final String id;
  final String title;
  final String? storeUrl;
  final String? imageUrl;
  final bool? isActive;
  final int? activeCoupons;
  final num? averageSavings;
  final int? totalCoupons;
  final num? popularityScore;
  final String? categoryId;
  final String? description;
  // Add whichever fields you actually use in your domain/UI

  const StoreEntity({
    this.description,
    this.categoryId,
    this.popularityScore,
    this.totalCoupons,
    this.activeCoupons,
    this.averageSavings,
    required this.id,
    required this.title,
    this.storeUrl,
    this.imageUrl,
    this.isActive,
  });
}

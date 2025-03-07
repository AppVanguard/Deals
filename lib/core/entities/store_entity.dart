import 'package:deals/core/entities/category_entity.dart';

class StoreEntity {
  final String id;
  final String title;
  final String storeUrl;
  final String? imageUrl;
  final bool isActive;
  final int? activeCoupons;
  final double? averageSavings;
  final int? totalCoupons;
  final double? popularityScore;
  final CategoryEntity? category;
  // Add whichever fields you actually use in your domain/UI

  const StoreEntity({
    required this.category,
    this.popularityScore,
    this.totalCoupons,
    this.activeCoupons,
    this.averageSavings,
    required this.id,
    required this.title,
    required this.storeUrl,
    this.imageUrl,
    required this.isActive,
  });
}

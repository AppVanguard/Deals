class CouponEntity {
  final String id;
  final String code;
  final String title;
  final DateTime? startDate;
  final DateTime? expiryDate;
  final num? discountValue;
  final String? image;
  final List<String>? termsAndConditions;
  final String? description;
  final num? cashBak;
  final bool? active;
  final String? storeUrl;

  // etc. Add discountValue, usageCount, successRate, etc. if needed

  const CouponEntity({
    this.active,
    this.cashBak,
    this.description,
    this.termsAndConditions,
    this.image,
    this.storeUrl,
    this.discountValue,
    required this.id,
    required this.code,
    required this.title,
    this.startDate,
    this.expiryDate,
  });
}

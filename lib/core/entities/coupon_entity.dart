class CouponEntity {
  final String id;
  final String code;
  final String title;
  final DateTime? startDate;
  final DateTime? expiryDate;
  final num? discountValue;
  final String? image;
  final List<String>? termsAndConditions;

  // etc. Add discountValue, usageCount, successRate, etc. if needed

  const CouponEntity({
    this.termsAndConditions,
    this.image,
    this.discountValue,
    required this.id,
    required this.code,
    required this.title,
    this.startDate,
    this.expiryDate,
  });
}

class CouponEntity {
  final String id;
  final String code;
  final String title;
  final DateTime? startDate;
  final DateTime? expiryDate;
  final int? discountValue;
  final String? image;

  // etc. Add discountValue, usageCount, successRate, etc. if needed

  const CouponEntity({
    this.image,
    this.discountValue,
    required this.id,
    required this.code,
    required this.title,
    this.startDate,
    this.expiryDate,
  });
}

class CouponEntity {
  final String id;
  final String code;
  final String title;
  final String? startDate;
  final String? expiryDate;
  final bool isActive;
  final bool? validForExisting;
  final bool? validForNew;
  final int? discountValue;
  final String? image;

  // etc. Add discountValue, usageCount, successRate, etc. if needed

  const CouponEntity({
    this.image,
    this.discountValue,
    this.validForNew,
    this.validForExisting,
    required this.id,
    required this.code,
    required this.title,
    this.startDate,
    this.expiryDate,
    required this.isActive,
  });
}

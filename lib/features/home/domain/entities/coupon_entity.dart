class CouponEntity {
  final String id;
  final String code;
  final String title;
  final DateTime? startDate;
  final String? expiryDate;
  final bool isActive;
  // etc. Add discountValue, usageCount, successRate, etc. if needed

  const CouponEntity({
    required this.id,
    required this.code,
    required this.title,
    this.startDate,
    this.expiryDate,
    required this.isActive,
  });
}

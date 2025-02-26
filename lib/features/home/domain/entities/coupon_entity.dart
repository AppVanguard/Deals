class CouponEntity {
  final String id;
  final String code;
  final String title;
  final bool isActive;

  const CouponEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.isActive,
  });
}

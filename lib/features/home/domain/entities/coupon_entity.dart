class CouponEntity {
  final String id;
  final String code;
  final String title;
  final bool isActive;
  final String status;
  const CouponEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.isActive,
    required this.status,
  });
}

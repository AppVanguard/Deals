class BookmarkEntity {
  final String id;
  final String? userId;
  final String? firebaseUid;
  final String storeId;
  final String? storeTitle;
  final String? storeImageUrl;
  final int? storeTotalCoupons;
  final int? storeCashbackRate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BookmarkEntity({
    required this.id,
    this.userId,
    this.firebaseUid,
    required this.storeId,
    this.storeTitle,
    this.storeImageUrl,
    this.storeTotalCoupons,
    this.storeCashbackRate,
    this.createdAt,
    this.updatedAt,
  });
}

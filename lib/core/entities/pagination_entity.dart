class PaginationEntity {
  final int currentPage;
  final int totalPages;
  final int? totalStores;
  final int? totalCategories;
  final int? totalCoupons;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PaginationEntity({
    this.totalCoupons,
    this.totalCategories,
    required this.currentPage,
    required this.totalPages,
    this.totalStores,
    required this.hasNextPage,
    required this.hasPrevPage,
  });
}

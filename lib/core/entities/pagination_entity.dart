class PaginationEntity {
  final int currentPage;
  final int totalPages;
  final int totalStores;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PaginationEntity({
    required this.currentPage,
    required this.totalPages,
    required this.totalStores,
    required this.hasNextPage,
    required this.hasPrevPage,
  });
}

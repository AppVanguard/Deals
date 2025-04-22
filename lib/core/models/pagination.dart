class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalCategories;
  int? totlaStores;
  int? totalCoupons;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.totalCoupons,
    this.totlaStores,
    this.currentPage,
    this.totalPages,
    this.totalCategories,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json['currentPage'] as int?,
        totalPages: json['totalPages'] as int?,
        totalCoupons: json['totalCoupons'] as int?,
        totlaStores: json['totalStores'] as int?,
        totalCategories: json['totalCategories'] as int?,
        hasNextPage: json['hasNextPage'] as bool?,
        hasPrevPage: json['hasPrevPage'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'totalPages': totalPages,
        'totalCategories': totalCategories,
        'hasNextPage': hasNextPage,
        'hasPrevPage': hasPrevPage,
      };
}

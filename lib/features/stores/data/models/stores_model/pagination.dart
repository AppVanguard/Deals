class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalStores;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalStores,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json['currentPage'] as int?,
        totalPages: json['totalPages'] as int?,
        totalStores: json['totalStores'] as int?,
        hasNextPage: json['hasNextPage'] as bool?,
        hasPrevPage: json['hasPrevPage'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'totalPages': totalPages,
        'totalStores': totalStores,
        'hasNextPage': hasNextPage,
        'hasPrevPage': hasPrevPage,
      };
}

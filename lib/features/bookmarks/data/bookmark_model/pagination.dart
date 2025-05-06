class Pagination {
  int? pageNumber;
  int? pageSize;
  int? itemsCount;
  int? totalPages;

  Pagination({
    this.pageNumber,
    this.pageSize,
    this.itemsCount,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        pageNumber: json['PageNumber'] as int?,
        pageSize: json['PageSize'] as int?,
        itemsCount: json['ItemsCount'] as int?,
        totalPages: json['totalPages'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'PageNumber': pageNumber,
        'PageSize': pageSize,
        'ItemsCount': itemsCount,
        'totalPages': totalPages,
      };
}

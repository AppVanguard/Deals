class Pagination {
  int? total;
  int? limit;
  int? offset;
  bool? hasMore;

  Pagination({this.total, this.limit, this.offset, this.hasMore});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json['total'] as int?,
        limit: json['limit'] as int?,
        offset: json['offset'] as int?,
        hasMore: json['hasMore'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'limit': limit,
        'offset': offset,
        'hasMore': hasMore,
      };
}

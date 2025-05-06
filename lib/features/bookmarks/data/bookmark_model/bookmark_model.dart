import 'bookmark_data.dart';
import 'pagination.dart';

class BookmarkModel {
  List<BookmarkData>? data;
  Pagination? pagination;

  BookmarkModel({this.data, this.pagination});

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => BookmarkData.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json['pagination'] == null
            ? null
            : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'pagination': pagination?.toJson(),
      };
}

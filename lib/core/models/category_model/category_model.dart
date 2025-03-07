import 'datum.dart';
import '../pagination.dart';

class CategoryModel {
  List<CategoryData>? data;
  Pagination? pagination;

  CategoryModel({this.data, this.pagination});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
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

import 'package:deals/core/models/pagination.dart';

import 'stores_data.dart';

class StoresModel {
  List<StoresData>? data;
  Pagination? pagination;

  StoresModel({this.data, this.pagination});

  factory StoresModel.fromJson(Map<String, dynamic> json) => StoresModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => StoresData.fromJson(e as Map<String, dynamic>))
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

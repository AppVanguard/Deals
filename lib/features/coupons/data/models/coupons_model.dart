import 'package:deals/core/models/pagination.dart';

import 'coupons_data.dart';

class CouponsModel {
  List<CouponsData>? data;
  Pagination? pagination;

  CouponsModel({this.data, this.pagination});

  factory CouponsModel.fromJson(Map<String, dynamic> json) => CouponsModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => CouponsData.fromJson(e as Map<String, dynamic>))
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

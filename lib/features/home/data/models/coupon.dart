import 'average_savings.dart';
import 'minimum_purchase.dart';
import 'valid_for.dart';

class Coupon {
  MinimumPurchase? minimumPurchase;
  ValidFor? validFor;
  AverageSavings? averageSavings;
  String? id;
  String? code;
  String? store;
  String? title;
  String? discountType;
  int? discountValue;
  List<dynamic>? termsAndConditions;
  DateTime? startDate;
  String? expiryDate;
  int? usageCount;
  int? successRate;
  int? popularityScore;
  bool? isVerified;
  bool? isFeatured;
  bool? isActive;
  String? status;
  dynamic deletedAt;
  List<dynamic>? verifiedBy;
  List<dynamic>? reportedNotWorking;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Coupon({
    this.minimumPurchase,
    this.validFor,
    this.averageSavings,
    this.id,
    this.code,
    this.store,
    this.title,
    this.discountType,
    this.discountValue,
    this.termsAndConditions,
    this.startDate,
    this.expiryDate,
    this.usageCount,
    this.successRate,
    this.popularityScore,
    this.isVerified,
    this.isFeatured,
    this.isActive,
    this.status,
    this.deletedAt,
    this.verifiedBy,
    this.reportedNotWorking,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        minimumPurchase: json['minimum_purchase'] == null
            ? null
            : MinimumPurchase.fromJson(
                json['minimum_purchase'] as Map<String, dynamic>),
        validFor: json['valid_for'] == null
            ? null
            : ValidFor.fromJson(json['valid_for'] as Map<String, dynamic>),
        averageSavings: json['average_savings'] == null
            ? null
            : AverageSavings.fromJson(
                json['average_savings'] as Map<String, dynamic>),
        id: json['_id'] as String?,
        code: json['code'] as String?,
        store: json['store'] as String?,
        title: json['title'] as String?,
        discountType: json['discount_type'] as String?,
        discountValue: json['discount_value'] as int?,
        termsAndConditions: json['terms_and_conditions'] as List<dynamic>?,
        startDate: json['start_date'] == null
            ? null
            : DateTime.parse(json['start_date'] as String),
        expiryDate:
            json['expiry_date'] == null ? null : json['expiry_date'] as String,
        usageCount: json['usage_count'] as int?,
        successRate: json['success_rate'] as int?,
        popularityScore: json['popularity_score'] as int?,
        isVerified: json['is_verified'] as bool?,
        isFeatured: json['is_featured'] as bool?,
        isActive: json['is_active'] as bool?,
        status: json['status'] as String?,
        deletedAt: json['deleted_at'] as dynamic,
        verifiedBy: json['verified_by'] as List<dynamic>?,
        reportedNotWorking: json['reported_not_working'] as List<dynamic>?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'minimum_purchase': minimumPurchase?.toJson(),
        'valid_for': validFor?.toJson(),
        'average_savings': averageSavings?.toJson(),
        '_id': id,
        'code': code,
        'store': store,
        'title': title,
        'discount_type': discountType,
        'discount_value': discountValue,
        'terms_and_conditions': termsAndConditions,
        'start_date': startDate?.toIso8601String(),
        'expiry_date': expiryDate,
        'usage_count': usageCount,
        'success_rate': successRate,
        'popularity_score': popularityScore,
        'is_verified': isVerified,
        'is_featured': isFeatured,
        'is_active': isActive,
        'status': status,
        'deleted_at': deletedAt,
        'verified_by': verifiedBy,
        'reported_not_working': reportedNotWorking,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'id': id,
      };
}

import 'average_savings.dart';
import 'minimum_purchase.dart';
import 'store.dart';
import 'valid_for.dart';

class CouponsData {
  String? id;
  String? code;
  Store? store;
  String? title;
  String? discountType;
  int? discountValue;
  MinimumPurchase? minimumPurchase;
  List<dynamic>? termsAndConditions;
  ValidFor? validFor;
  String? startDate;
  String? expiryDate;
  int? usageCount;
  int? successRate;
  AverageSavings? averageSavings;
  int? popularityScore;
  bool? isVerified;
  bool? isFeatured;
  bool? isActive;
  String? status;
  dynamic deletedAt;
  List<dynamic>? verifiedBy;
  List<dynamic>? reportedNotWorking;
  String? createdAt;
  String? updatedAt;
  int? v;

  CouponsData({
    this.id,
    this.code,
    this.store,
    this.title,
    this.discountType,
    this.discountValue,
    this.minimumPurchase,
    this.termsAndConditions,
    this.validFor,
    this.startDate,
    this.expiryDate,
    this.usageCount,
    this.successRate,
    this.averageSavings,
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

  factory CouponsData.fromJson(Map<String, dynamic> json) => CouponsData(
        id: json['_id'] as String?,
        code: json['code'] as String?,
        store: json['store'] == null
            ? null
            : Store.fromJson(json['store'] as Map<String, dynamic>),
        title: json['title'] as String?,
        discountType: json['discount_type'] as String?,
        discountValue: json['discount_value'] as int?,
        minimumPurchase: json['minimum_purchase'] == null
            ? null
            : MinimumPurchase.fromJson(
                json['minimum_purchase'] as Map<String, dynamic>),
        termsAndConditions: json['terms_and_conditions'] as List<dynamic>?,
        validFor: json['valid_for'] == null
            ? null
            : ValidFor.fromJson(json['valid_for'] as Map<String, dynamic>),
        startDate:
            json['start_date'] == null ? null : json['start_date'] as String,
        expiryDate:
            json['expiry_date'] == null ? null : json['expiry_date'] as String,
        usageCount: json['usage_count'] as int?,
        successRate: json['success_rate'] as int?,
        averageSavings: json['average_savings'] == null
            ? null
            : AverageSavings.fromJson(
                json['average_savings'] as Map<String, dynamic>),
        popularityScore: json['popularity_score'] as int?,
        isVerified: json['is_verified'] as bool?,
        isFeatured: json['is_featured'] as bool?,
        isActive: json['is_active'] as bool?,
        status: json['status'] as String?,
        deletedAt: json['deleted_at'] as dynamic,
        verifiedBy: json['verified_by'] as List<dynamic>?,
        reportedNotWorking: json['reported_not_working'] as List<dynamic>?,
        createdAt:
            json['createdAt'] == null ? null : json['createdAt'] as String,
        updatedAt:
            json['updatedAt'] == null ? null : json['updatedAt'] as String,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'code': code,
        'store': store?.toJson(),
        'title': title,
        'discount_type': discountType,
        'discount_value': discountValue,
        'minimum_purchase': minimumPurchase?.toJson(),
        'terms_and_conditions': termsAndConditions,
        'valid_for': validFor?.toJson(),
        'start_date': startDate,
        'expiry_date': expiryDate,
        'usage_count': usageCount,
        'success_rate': successRate,
        'average_savings': averageSavings?.toJson(),
        'popularity_score': popularityScore,
        'is_verified': isVerified,
        'is_featured': isFeatured,
        'is_active': isActive,
        'status': status,
        'deleted_at': deletedAt,
        'verified_by': verifiedBy,
        'reported_not_working': reportedNotWorking,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}

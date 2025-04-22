class MinimumPurchase {
  String? currency;

  MinimumPurchase({this.currency});

  factory MinimumPurchase.fromJson(Map<String, dynamic> json) {
    return MinimumPurchase(
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'currency': currency,
      };
}

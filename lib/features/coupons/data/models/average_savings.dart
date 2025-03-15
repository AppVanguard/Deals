class AverageSavings {
  String? currency;

  AverageSavings({this.currency});

  factory AverageSavings.fromJson(Map<String, dynamic> json) {
    return AverageSavings(
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'currency': currency,
      };
}

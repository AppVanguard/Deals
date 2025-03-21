class Cashback {
  int? rate;
  List<String>? terms;

  Cashback({this.rate, this.terms});

  factory Cashback.fromJson(Map<String, dynamic> json) => Cashback(
        rate: json['rate'] == null ? null : (json['rate'] as num).toInt(),
        terms: json['terms'] == null
            ? null
            : List<String>.from(json['terms'] as List),
      );

  Map<String, dynamic> toJson() => {
        'rate': rate,
        'terms': terms,
      };
}

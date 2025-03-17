class Cashback {
  int? rate;
  List<String>? terms;

  Cashback({this.rate, this.terms});

  factory Cashback.fromJson(Map<String, dynamic> json) => Cashback(
        rate: json['rate'] as int?,
        terms:
            (json['terms'] as List<dynamic>?)?.map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => {
        'rate': rate,
        'terms': terms,
      };
}

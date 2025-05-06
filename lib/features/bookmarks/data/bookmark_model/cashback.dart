class Cashback {
  int? rate;

  Cashback({this.rate});

  factory Cashback.fromJson(Map<String, dynamic> json) => Cashback(
        rate: json['rate'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'rate': rate,
      };
}

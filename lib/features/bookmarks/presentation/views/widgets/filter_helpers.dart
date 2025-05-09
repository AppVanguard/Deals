enum OfferType { all, coupons, cashback }

enum OrderType { lowToHigh, highToLow }

extension OfferTypeX on OfferType {
  String get label {
    switch (this) {
      case OfferType.coupons:
        return 'Coupons';
      case OfferType.cashback:
        return 'Cashback';
      case OfferType.all:
        return 'Cashback & Coupons';
    }
  }

  bool get hasCoupons => this == OfferType.coupons;
  bool get hasCashback => this == OfferType.cashback;
}

extension OrderTypeX on OrderType {
  String get label =>
      this == OrderType.lowToHigh ? 'Low to High' : 'High to Low';
  String get value => this == OrderType.lowToHigh ? 'asc' : 'desc';
}

// lib/features/search/presentation/views/filter_dialog/filter_option.dart

enum FilterOption { cashback, coupons, cashbackAndCoupons }

enum OrderOption { lowToHigh, highToLow }

extension FilterOptionExtension on FilterOption {
  String get label {
    switch (this) {
      case FilterOption.cashback:
        return 'Cashback';
      case FilterOption.coupons:
        return 'Coupons';
      case FilterOption.cashbackAndCoupons:
        return 'Cashback & Coupons';
    }
  }
}

extension OrderOptionExtension on OrderOption {
  String get label {
    switch (this) {
      case OrderOption.lowToHigh:
        return 'Low to High';
      case OrderOption.highToLow:
        return 'High to Low';
    }
  }

  String get value {
    switch (this) {
      case OrderOption.lowToHigh:
        return 'asc';
      case OrderOption.highToLow:
        return 'desc';
    }
  }
}

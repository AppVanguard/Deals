class ValidFor {
  bool? newCustomers;
  bool? existingCustomers;
  List<dynamic>? specificItems;
  List<dynamic>? specificCategories;

  ValidFor({
    this.newCustomers,
    this.existingCustomers,
    this.specificItems,
    this.specificCategories,
  });

  factory ValidFor.fromJson(Map<String, dynamic> json) => ValidFor(
        newCustomers: json['new_customers'] as bool?,
        existingCustomers: json['existing_customers'] as bool?,
        specificItems: json['specific_items'] as List<dynamic>?,
        specificCategories: json['specific_categories'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'new_customers': newCustomers,
        'existing_customers': existingCustomers,
        'specific_items': specificItems,
        'specific_categories': specificCategories,
      };
}

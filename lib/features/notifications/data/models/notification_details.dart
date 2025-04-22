class NotificationDetails {
  final String? store;
  final String? storeName;
  final String? image;
  final String? coupon;

  NotificationDetails({
    this.store,
    this.storeName,
    this.image,
    this.coupon,
  });

  factory NotificationDetails.fromJson(Map<String, dynamic> json) =>
      NotificationDetails(
        store: json['store'] as String?,
        storeName: json['storeName'] as String?,
        image: json['image'] as String?,
        coupon: json['coupon'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'store': store,
        'storeName': storeName,
        'image': image,
        'coupon': coupon,
      };
}

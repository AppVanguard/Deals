import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:flutter/material.dart';

class CouponsTab extends StatelessWidget {
  const CouponsTab({super.key, this.storeEntity, this.coupons});
  final StoreEntity? storeEntity;
  final List<CouponEntity>? coupons;
  @override
  Widget build(BuildContext context) {
    // List of coupons or any other data
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Coupons",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text("• Coupon A: 15% off on orders above \$100"),
        Text("• Coupon B: \$10 off on first order"),
      ],
    );
  }
}

import 'package:deals/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CouponDetailsView extends StatelessWidget {
  const CouponDetailsView({super.key, required this.couponId});
  static const routeName = '/coupon_details';
  final String couponId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(child: Text(couponId)),
    );
  }
}

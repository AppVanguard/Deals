import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';
import 'package:in_pocket/generated/l10n.dart';

class TopCoupons extends StatelessWidget {
  const TopCoupons({super.key, required this.coupons});

  /// List of coupons from your HomeEntity
  final List<CouponEntity> coupons;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              // First row (half the list, rounded up)
              Row(
                children: List.generate((coupons.length / 2).ceil(), (index) {
                  final coupon = coupons[index];
                  return _CouponCard(coupon: coupon);
                }),
              ),
              const SizedBox(height: 16),
              // Second row (remaining half, rounded down)
              Row(
                children: List.generate((coupons.length / 2).floor(), (index) {
                  final adjustedIndex = index + (coupons.length / 2).ceil();
                  if (adjustedIndex >= coupons.length) {
                    // if there's an odd number of coupons, we avoid errors
                    return const SizedBox();
                  }
                  final coupon = coupons[adjustedIndex];
                  return _CouponCard(coupon: coupon);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.coupon});

  final CouponEntity coupon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.grey[200], // or your preferred background
              borderRadius: BorderRadius.circular(10),
            ),
            // If you have a coupon image in your backend, you can load it here:
            // e.g. Image.network(...) or a local asset if not
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Icon(
                Icons.card_giftcard,
                size: 80,
                color: Colors.grey,
              ),
            ),
          ),
          // The coupon’s title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              coupon.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Example: show whether the coupon is active
          Text(
            coupon.isActive
                ? S.of(context).Coupon_Active
                : S.of(context).Coupon_Expired,
            style: const TextStyle(color: AppColors.accent),
          ),
          // If you have discount values or codes, display them as well:
          Text('Code: ${coupon.code}'),
        ],
      ),
    );
  }
}

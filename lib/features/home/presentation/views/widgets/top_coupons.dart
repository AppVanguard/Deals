// top_coupons.dart

import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';

class TopCoupons extends StatelessWidget {
  final List<CouponEntity> coupons;
  final bool isLoading;

  const TopCoupons({
    super.key,
    required this.coupons,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // If no coupons
    if (coupons.isEmpty) {
      if (!isLoading) {
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: Center(child: Text('No coupons found')),
          ),
        );
      }
      // If still loading, show placeholders
      return _buildPlaceholderRows();
    }

    // If real data
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              // First row
              Row(
                children: List.generate(
                  (coupons.length / 2).ceil(),
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _CouponCard(
                      coupon: coupons[index],
                      isLoading: isLoading,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Second row
              Row(
                children: List.generate(
                  (coupons.length / 2).floor(),
                  (idx) {
                    final adjustedIndex = idx + (coupons.length / 2).ceil();
                    if (adjustedIndex >= coupons.length) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _CouponCard(
                        coupon: coupons[adjustedIndex],
                        isLoading: isLoading,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderRows() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              // First row
              Row(
                children: List.generate(2, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: _CouponPlaceholderCard(),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Second row
              Row(
                children: List.generate(2, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: _CouponPlaceholderCard(),
                  );
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
  final CouponEntity coupon;
  final bool isLoading;

  const _CouponCard({
    required this.coupon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: AppColors.tertiaryText,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: SizedBox(
                height: 80,
                child: Icon(
                  Icons.card_giftcard,
                  size: 50,
                  color: AppColors.tertiaryText,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            coupon.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            coupon.isActive ? 'Coupon Active' : 'Coupon Inactive',
            style: const TextStyle(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text('Code: ${coupon.code}'),
        ],
      ),
    );
  }
}

// Placeholder card
class _CouponPlaceholderCard extends StatelessWidget {
  const _CouponPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.tertiaryText,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 16,
            color: AppColors.tertiaryText,
          ),
          const SizedBox(height: 4),
          Container(
            width: 80,
            height: 16,
            color: AppColors.tertiaryText,
          ),
          const SizedBox(height: 4),
          Container(
            width: 120,
            height: 16,
            color: AppColors.tertiaryText,
          ),
        ],
      ),
    );
  }
}

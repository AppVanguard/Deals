import 'package:deals/features/coupons/presentation/views/widgets/coupons_coupon_ticket.dart';
import 'package:deals/features/stores/presentation/views/widgets/store_coupon_ticket.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';

class CouponsTabSliver extends StatelessWidget {
  const CouponsTabSliver({
    super.key,
    required this.storeEntity,
    required this.coupons,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasNextPage,
  });

  final StoreEntity? storeEntity;
  final List<CouponEntity> coupons;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNextPage;

  @override
  Widget build(BuildContext context) {
    // If loading with no coupons => skeleton items
    if (isLoading && coupons.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, idx) => const CouponItemSkeleton(),
          childCount: 5,
        ),
      );
    }

    // If we have no data, show error or fallback
    if (!isLoading && storeEntity == null && coupons.isEmpty) {
      return SliverFillRemaining(
        child: buildCustomErrorScreen(
          context: context,
          onRetry: () {
            // Possibly fetch again
          },
        ),
      );
    }

    // Otherwise build the real list
    final itemCount = coupons.length + (hasNextPage && isLoadingMore ? 1 : 0);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, index) {
          if (index >= coupons.length) {
            // Show skeleton row if we are still loading more
            return const CouponItemSkeleton();
          }
          final coupon = coupons[index];
          return CouponItem(coupon: coupon);
        },
        childCount: itemCount,
      ),
    );
  }
}

class CouponItem extends StatelessWidget {
  const CouponItem({super.key, required this.coupon});
  final CouponEntity coupon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: StoreCouponTicket(
        buttonText: 'Get Code',
        expirationText: 'd',
        title: coupon.title,
        code: coupon.code,
        discountValue: coupon.discountValue,
        imageUrl: coupon.image,
        expiryDate: coupon.expiryDate,
        width: MediaQuery.of(context).size.width * 0.8,
        height: 150,
        onPressed: () {
          // handle coupon pressed
        },
      ),
    );
  }
}

class CouponItemSkeleton extends StatelessWidget {
  const CouponItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Skeletonizer(
        child: StoreCouponTicket(
          buttonText: '',
          expirationText: '',
          title: 'Loading...',
          code: 'Loading...',
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          onPressed: () {},
        ),
      ),
    );
  }
}

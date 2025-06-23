import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/coupons/presentation/views/coupon_details_view.dart';
import 'package:deals/features/stores/presentation/views/widgets/store_coupon_ticket.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    // 1) Initial loading with no coupons => show 5 skeleton items.
    if (isLoading && coupons.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, idx) => const CouponItemSkeleton(),
          childCount: 5,
        ),
      );
    }

    // 2) If we have no data (and not loading), show an error/fallback screen.
    if (!isLoading && storeEntity == null && coupons.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: buildCustomErrorScreen(
          context: context,
          onRetry: () {
            // Possibly trigger a refetch.
          },
        ),
      );
    }

    // 3) Otherwise, build the list of coupons.
    //    When loading more (pagination), add 3 skeleton items at the end.
    final skeletonCount = (hasNextPage && isLoadingMore) ? 3 : 0;
    final itemCount = coupons.length + skeletonCount;

    // Increase the bottom padding (e.g. 120) so the last item isn't hidden.
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 200, top: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, index) {
            // If we're in the skeleton portion at the end:
            if (index >= coupons.length) {
              return const CouponItemSkeleton();
            }
            // Otherwise, show a real coupon
            final coupon = coupons[index];
            return CouponItem(coupon: coupon);
          },
          childCount: itemCount,
        ),
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
        terms: coupon.termsAndConditions,
        buttonColor: AppColors.accent,
        buttonText: S.of(context).getCode,
        expirationText: _buildExpirationText(coupon.expiryDate),
        discountValue: coupon.discountValue ?? 0,
        imageUrl: coupon.image,
        expiryDate: coupon.expiryDate,
        width: MediaQuery.of(context).size.width * 0.8,
        height: 150,
        onPressed: () {
          context.pushNamed(
            CouponDetailsView.routeName,
            extra: coupon.id,
          );
        },
      ),
    );
  }

  String _buildExpirationText(DateTime? expiryDate) {
    if (expiryDate == null) {
      return '';
    }
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;
    if (difference <= 0) {
      return 'Expired';
    } else {
      final dayString = difference == 1 ? 'day' : 'days';
      return 'Expires in $difference $dayString';
    }
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
          terms: const ['Loading...', 'Loading...'],
          buttonColor: AppColors.tertiaryText,
          buttonText: 'Loading...',
          expirationText: 'Loading...',
          discountValue: 0,
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          onPressed: () {},
        ),
      ),
    );
  }
}

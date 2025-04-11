import 'package:deals/features/coupons/presentation/views/coupon_view.dart';
import 'package:deals/features/stores/presentation/views/stores_view.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/features/home/domain/entities/home_entity.dart';
import 'package:deals/features/home/presentation/views/widgets/sales_carousel.dart';
import 'package:deals/features/home/presentation/views/widgets/top_coupons.dart';
import 'package:deals/features/home/presentation/views/widgets/top_stores.dart';
import 'package:deals/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class HomeContent extends StatelessWidget {
  final HomeEntity? homeEntity;
  final bool isLoading;

  const HomeContent({
    super.key,
    required this.homeEntity,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // If homeEntity is null, we pass empty lists
    final announcements = homeEntity?.announcements ?? [];
    final stores = homeEntity?.stores ?? [];
    final coupons = homeEntity?.coupons ?? [];

    return CustomScrollView(
      slivers: [
        // Some header text
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).Save_money_with_us,
              style: AppTextStyles.bold20,
            ),
          ),
        ),
        // Sales carousel for announcements
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SalesCarousel(
              announcements: announcements,
              isLoading: isLoading,
            ),
          ),
        ),
        // Top Stores section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).Top_stores,
                  style: AppTextStyles.bold18,
                ),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(StoresView.routeName);
                  },
                  child: Text(
                    S.of(context).See_All,
                    style: AppTextStyles.regular14.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TopStores(
          stores: stores,
          isLoading: isLoading,
        ),
        // Top Coupons section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).Top_coupons,
                  style: AppTextStyles.bold18,
                ),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(CouponView.routeName);
                  },
                  child: Text(
                    S.of(context).See_All,
                    style: AppTextStyles.regular14.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TopCoupons(
          coupons: coupons,
          isLoading: isLoading,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }
}

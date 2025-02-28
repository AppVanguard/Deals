// home_content.dart

import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/sales_carousel.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/top_coupons.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/top_stores.dart';
import 'package:in_pocket/generated/l10n.dart';

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
    // If we have real data, extract it; else keep empty lists
    final announcements = homeEntity?.announcements ?? [];
    final stores = homeEntity?.stores ?? [];
    final coupons = homeEntity?.coupons ?? [];

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).Save_money_with_us,
              style: AppTextStyles.bold20,
            ),
          ),
        ),
        // Carousel
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SalesCarousel(
              announcements: announcements,
              isLoading: isLoading,
            ),
          ),
        ),
        // Top Stores Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).Top_stores, style: AppTextStyles.bold18),
                Text(
                  S.of(context).See_All,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.primary,
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
        // Top Coupons Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).Top_coupons, style: AppTextStyles.bold18),
                Text(
                  S.of(context).See_All,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.primary,
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
      ],
    );
  }
}

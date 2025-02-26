// home_content.dart

import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/sales_carousel.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/top_coupons.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/top_stores.dart';
import 'package:in_pocket/generated/l10n.dart';

class HomeContent extends StatelessWidget {
  final HomeEntity homeEntity;

  const HomeContent({super.key, required this.homeEntity});

  @override
  Widget build(BuildContext context) {
    final announcements = homeEntity.announcements;
    final stores = homeEntity.stores;
    final coupons = homeEntity.coupons;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              S.of(context).Save_money_with_us,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Example "sales carousel"
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SalesCarousel(),
          ),
        ),

        // Top Stores
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).Top_stores,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(S.of(context).See_All,
                    style: TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
        ),
        TopStores(stores: stores),

        // Top Coupons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).Top_coupons,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(S.of(context).See_All,
                    style: TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
        ),
        TopCoupons(coupons: coupons),
      ],
    );
  }
}

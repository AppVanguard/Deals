// home_content.dart

import 'package:flutter/material.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/sales_carousel.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/top_coupons.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/top_stores.dart';

class HomeContent extends StatelessWidget {
  final HomeEntity? homeEntity;
  final bool isLoading;

  const HomeContent({
    Key? key,
    required this.homeEntity,
    required this.isLoading,
  }) : super(key: key);

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
              'Save money with us',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              children: const [
                Text('Top stores',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See All', style: TextStyle(color: Colors.blue)),
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
              children: const [
                Text('Top coupons',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See All', style: TextStyle(color: Colors.blue)),
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

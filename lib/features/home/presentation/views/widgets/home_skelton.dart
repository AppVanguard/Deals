import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 1) Shimmer for the "header" text
        _buildShimmerBox(height: 30, width: 200),

        const SizedBox(height: 20),
        // 2) Shimmer for the "carousel" area
        _buildShimmerBox(height: 150, width: double.infinity),

        const SizedBox(height: 20),
        // 3) Shimmer for "Top stores" heading
        _buildShimmerBox(height: 20, width: 120),

        const SizedBox(height: 12),
        // 4) Shimmer for a horizontal list of store items
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4, // e.g. 4 placeholders
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => _buildStorePlaceholder(context),
          ),
        ),

        const SizedBox(height: 20),
        // 5) Shimmer for "Top coupons" heading
        _buildShimmerBox(height: 20, width: 120),

        const SizedBox(height: 12),
        // 6) Shimmer for a horizontal list of coupon items
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4, // 4 placeholders
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => _buildCouponPlaceholder(context),
          ),
        ),
      ],
    );
  }

  /// A helper to build a simple shimmer box
  Widget _buildShimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        color: Colors.grey.shade300,
      ),
    );
  }

  /// A helper to mimic a "store card" shape
  Widget _buildStorePlaceholder(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// A helper to mimic a "coupon card" shape
  Widget _buildCouponPlaceholder(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/coupon_placeholder_ticket.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/coupon_ticket.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';

/// The main widget that displays coupons in two horizontal rows:
/// - If no data + not loading => "No coupons found"
/// - If no data + loading => placeholders
/// - Otherwise => real coupons
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
    if (coupons.isEmpty) {
      if (!isLoading) {
        // Not loading + empty => no coupons
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: Center(child: Text('No coupons found')),
          ),
        );
      }
      // Still loading + empty => placeholders
      return _buildPlaceholderRows();
    }

    // We have data => build the two-row structure
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 16), // left padding
              Column(
                children: [
                  // First row: half the coupons (rounded up)
                  Row(
                    children: List.generate(
                      (coupons.length / 2).ceil(),
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CouponTicket(
                          coupon: coupons[index],
                          isLoading: isLoading,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Second row: the remaining half
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
                          child: CouponTicket(
                            coupon: coupons[adjustedIndex],
                            isLoading: isLoading,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a 2x2 matrix of placeholder tickets (4 total)
  /// when data is empty but we're loading.
  Widget _buildPlaceholderRows() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              // First row: 2 placeholders
              Row(
                children: List.generate(2, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: CouponPlaceholderTicket(),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Second row: 2 placeholders
              Row(
                children: List.generate(2, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: CouponPlaceholderTicket(),
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

import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/features/coupons/presentation/views/coupon_details_view.dart';
import 'package:deals/features/home/presentation/views/widgets/home_coupon_ticket.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Horizontal list of the most popular coupons.

class TopCoupons extends StatefulWidget {
  /// Coupon items to display.
  final List<dynamic> coupons;

  /// Indicates whether skeleton placeholders should be shown.
  final bool isLoading;

  const TopCoupons({
    super.key,
    required this.coupons,
    required this.isLoading,
  });

  @override
  State<TopCoupons> createState() => _TopCouponsState();
}

class _TopCouponsState extends State<TopCoupons> {
  late bool localIsLoading;

  @override
  void initState() {
    super.initState();
    localIsLoading = widget.isLoading;
  }

  @override
  void didUpdateWidget(covariant TopCoupons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      setState(() {
        localIsLoading = widget.isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no coupons and not loading => show "No coupons found".
    if (widget.coupons.isEmpty && !localIsLoading) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: Center(child: Text('No coupons found')),
        ),
      );
    }

    // If loading and empty => placeholder coupons
    // Otherwise => real coupons
    final displayCoupons = localIsLoading && widget.coupons.isEmpty
        ? List.generate(4, (_) => null) // placeholders
        : widget.coupons;

    final firstRowCount = (displayCoupons.length / 2).ceil();
    final secondRowCount = (displayCoupons.length / 2).floor();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Column(
                children: [
                  // First row
                  Row(
                    children: List.generate(
                      firstRowCount,
                      (index) {
                        final coupon = displayCoupons[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildCouponTicket(
                              context, coupon, localIsLoading),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Second row
                  Row(
                    children: List.generate(
                      secondRowCount,
                      (idx) {
                        final adjustedIndex = idx + firstRowCount;
                        if (adjustedIndex >= displayCoupons.length) {
                          return const SizedBox();
                        }
                        final coupon = displayCoupons[adjustedIndex];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildCouponTicket(
                              context, coupon, localIsLoading),
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

  Widget _buildCouponTicket(
      BuildContext context, CouponEntity? coupon, bool isLoading) {
    // If coupon is null => placeholder
    if (coupon == null) {
      return Skeletonizer(
        enabled: isLoading,
        child: HomeCouponTicket(
          title: 'Loading...',
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          onPressed: () {},
        ),
      );
    } else {
      return Skeletonizer(
        enabled: isLoading,
        child: HomeCouponTicket(
          title: coupon.title,
          discountValue: coupon.discountValue,
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
  }
}

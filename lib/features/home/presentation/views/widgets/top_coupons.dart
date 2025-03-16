import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/widgets/coupon_ticket/coupon_ticket.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'coupon_entity.dart'; // wherever you keep your real CouponEntity

class TopCoupons extends StatefulWidget {
  // Replace `dynamic` with your actual CouponEntity type
  final List<dynamic> coupons;
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

    // Build two rows: first row => ceil(count/2), second row => floor(count/2)
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
        child: CouponTicket(
          title: 'Loading...',
          code: 'Loading...',
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          onPressed: () {},
        ),
      );
    } else {
      // If you have real fields, cast and pass them here
      // final c = coupon as CouponEntity;
      return Skeletonizer(
        enabled: isLoading,
        child: CouponTicket(
          title: coupon.title,
          code: coupon.code,
          discountValue: coupon.discountValue,
          imageUrl: coupon.image,
          expiryDate: coupon.expiryDate,
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          onPressed: () {
            // handle click
          },
        ),
      );
    }
  }
}

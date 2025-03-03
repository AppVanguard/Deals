import 'package:flutter/material.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/widgets/coupon_ticket/coupon_ticket.dart';

/// The main widget that displays coupons in two horizontal rows:
/// - If no data and not loading => "No coupons found"
/// - If loading (or coupons list is empty) => show placeholder tickets (2 rows)
/// - Otherwise, show real coupons.
class TopCoupons extends StatefulWidget {
  final List<CouponEntity> coupons;
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
    // If there are no coupons and we're not loading, show a "No coupons found" message.
    if (widget.coupons.isEmpty && !localIsLoading) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: Center(child: Text('No coupons found')),
        ),
      );
    }

    // When loading and coupons list is empty, we generate placeholder coupons.
    // Otherwise, we use the real coupon list.
    final List<CouponEntity> displayCoupons =
        localIsLoading && widget.coupons.isEmpty
            ? List.generate(
                12,
                (_) => const CouponEntity(
                  id: '',
                  code: '',
                  title: '',
                  isActive: false,
                ),
              )
            : widget.coupons;

    // Build two rows: first row with ceil(count/2) and second row with floor(count/2)
    final int firstRowCount = (displayCoupons.length / 2).ceil();
    final int secondRowCount = (displayCoupons.length / 2).floor();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              const SizedBox(width: 16), // left padding
              Column(
                children: [
                  // First row
                  Row(
                    children: List.generate(
                      firstRowCount,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CouponTicket(
                          coupon: displayCoupons[index],
                          isLoading: localIsLoading,
                        ),
                      ),
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
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: CouponTicket(
                            coupon: displayCoupons[adjustedIndex],
                            isLoading: localIsLoading,
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
}

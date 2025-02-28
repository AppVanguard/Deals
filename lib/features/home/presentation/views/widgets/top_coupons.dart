import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';

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
    // If no coupons at all
    if (coupons.isEmpty) {
      if (!isLoading) {
        // No data, not loading
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: Center(child: Text('No coupons found')),
          ),
        );
      }
      // No data, still loading => placeholders
      return _buildPlaceholderRows();
    }

    // Otherwise, we have real coupon data
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 16),
              Column(
                children: [
                  // First row
                  Row(
                    children: List.generate(
                      (coupons.length / 2).ceil(),
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _CouponCard(
                            coupon: coupons[index],
                            isLoading: isLoading,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Second row
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
                          child: _CouponCard(
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

  // Build 4 placeholders if there's no data but we're loading
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
                    child: _CouponPlaceholderCard(),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Second row: 2 placeholders
              Row(
                children: List.generate(2, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: _CouponPlaceholderCard(),
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

/// The real coupon card with a rectangular shape,
/// circular notches on left/right centers, and a dashed divider
class _CouponCard extends StatelessWidget {
  final CouponEntity coupon;
  final bool isLoading;

  const _CouponCard({
    Key? key,
    required this.coupon,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The user’s design calls for about 328 width x 116 height
    final cardWidth = MediaQuery.of(context).size.width * 0.8;
    const cardHeight = 116.0;

    return Skeletonizer(
      enabled: isLoading,
      child: Material(
        shadowColor: Colors.transparent, // no shadow
        surfaceTintColor: Colors.transparent,
        elevation: 1, // subtle shadow
        color: Colors.transparent,
        // We use shape or clipBehavior if needed, but let's do ClipPath directly
        child: ClipPath(
          clipper: RectTicketClipper(
            holeRadius: 14, // size of the side holes
          ),
          child: Container(
            width: cardWidth,
            height: cardHeight,
            color: Colors.green, // card background
            child: Row(
              children: [
                // Left side: brand image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    // Suppose coupon has storeLogoUrl
                    child: Image.network(
                      coupon.id ?? '',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                // Dashed vertical line
                SizedBox(
                  height: cardHeight * 0.8,
                  child: CustomPaint(
                    painter: DashedLinePainter(
                      color: Colors.grey.shade600,
                      dashHeight: 5,
                      dashSpace: 3,
                      strokeWidth: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Right side: coupon info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.title ?? 'H&M',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // e.g. "New users discount 30% off"
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: 'New users discount '),
                              TextSpan(
                                text: '30% off',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'valid until 18 Aug',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder card, same shape & size, but gray
class _CouponPlaceholderCard extends StatelessWidget {
  const _CouponPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.8;
    const cardHeight = 116.0;

    return Skeletonizer(
      enabled: true,
      child: Material(
        elevation: 1,
        color: Colors.white,
        child: ClipPath(
          clipper: RectTicketClipper(holeRadius: 14),
          child: Container(
            width: cardWidth,
            height: cardHeight,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
// A clipper that creates a perfect rectangle with
// circular notches (holes) on the left & right edges at center.
// NO corner rounding => sharp corners
//------------------------------------------------------------------------------
class RectTicketClipper extends CustomClipper<Path> {
  final double holeRadius;

  RectTicketClipper({this.holeRadius = 14.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final centerY = h / 2;
    final topHoleY = centerY - holeRadius;
    final bottomHoleY = centerY + holeRadius;

    // Start top-left corner
    path.moveTo(0, 0);
    // Top edge to top-right corner
    path.lineTo(w, 0);

    // Right side hole
    path.lineTo(w, topHoleY);
    path.arcToPoint(
      Offset(w, bottomHoleY),
      radius: Radius.circular(holeRadius),
      clockwise: false,
    );
    // then down to bottom-right corner
    path.lineTo(w, h);

    // bottom edge back to bottom-left
    path.lineTo(0, h);

    // left side hole
    path.lineTo(0, bottomHoleY);
    path.arcToPoint(
      Offset(0, topHoleY),
      radius: Radius.circular(holeRadius),
      clockwise: false,
    );
    // up to top-left corner
    path.close();

    return path;
  }

  @override
  bool shouldReclip(RectTicketClipper oldClipper) =>
      holeRadius != oldClipper.holeRadius;
}

//------------------------------------------------------------------------------
// A painter for a vertical dashed line
//------------------------------------------------------------------------------
class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double dashSpace;
  final double strokeWidth;

  DashedLinePainter({
    this.color = Colors.grey,
    this.dashHeight = 5,
    this.dashSpace = 3,
    this.strokeWidth = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) => false;
}

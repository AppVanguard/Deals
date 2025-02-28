import 'package:flutter/material.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/coupon_placeholder_ticket.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/dashed_line_painter.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/rect_ticket_clipper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CouponTicket extends StatelessWidget {
  final CouponEntity coupon;
  final bool isLoading;

  const CouponTicket({
    super.key,
    required this.coupon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // ~328 wide x 116 tall (from your design specs)
    final cardWidth = MediaQuery.of(context).size.width * 0.8;
    const cardHeight = 116.0;

    return Skeletonizer(
      enabled: isLoading,
      child: PhysicalShape(
        elevation: 4,
        shadowColor: Colors.black54,
        color: Colors.white, // the card background
        clipper: RectTicketClipper(holeRadius: 14),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Row(
            children: [
              // Left side: brand image or logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  // Example: coupon.storeLogoUrl? or coupon.id?
                  child: Image.network(
                    coupon.id ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) =>
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
              // Right side: coupon text info
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
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(text: 'New users discount '),
                            TextSpan(
                              text: '30% off',
                              style: TextStyle(
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
    );
  }
}

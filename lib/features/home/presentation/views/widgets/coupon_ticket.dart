import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/dashed_line_painter.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/rect_ticket_clipper.dart';

class CouponTicket extends StatelessWidget {
  final CouponEntity coupon;
  final bool isLoading;

  const CouponTicket({
    Key? key,
    required this.coupon,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.8;
    const cardHeight = 116.0;

    // Parse and format expiry date string
    String formattedDate = '';
    if (coupon.expiryDate != null) {
      final parsed = DateTime.tryParse(coupon.expiryDate!);
      if (parsed != null) {
        formattedDate = DateFormat('d MMM').format(parsed);
      }
    }

    return Skeletonizer(
      enabled: isLoading,
      child: PhysicalShape(
        elevation: 4,
        shadowColor: Colors.black54,
        color: Colors.white,
        clipper: const RectTicketClipper(holeRadius: 14),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Row(
            children: [
              // Left: brand image/logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    coupon.id ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, error, stack) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              // Dashed vertical divider
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
              // Right: coupon info text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 12.0),
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
                      const Text(
                        'New users discount 30% off',
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate.isNotEmpty
                            ? 'valid until $formattedDate'
                            : 'valid until ...',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
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

import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/generated/l10n.dart';
import 'package:intl/intl.dart'; // for DateFormat
import 'package:skeletonizer/skeletonizer.dart';
import 'package:in_pocket/features/home/domain/entities/coupon_entity.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/dashed_line_painter.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/rect_ticket_clipper.dart';

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
    final cardWidth = MediaQuery.sizeOf(context).width * 0.8;
    final cardHeight = 116.0;

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
        clipBehavior:
            Clip.antiAlias, // ensure full anti-aliased shadow around shape
        elevation: 5,
        shadowColor: Colors.black,
        color: Colors.white,
        clipper: const RectTicketClipper(holeRadius: 16),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Row(
            children: [
              SizedBox(
                width: 12,
              ),
              // Left: brand image/logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: 66,
                  height: 66,
                  child: Image.network(
                    coupon.id,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, error, stack) => Image.asset(
                        AppImages.assetsImagesTest2,
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              // Dashed vertical divider
              SizedBox(
                height: cardHeight * 0.8,
                child: CustomPaint(
                  painter: DashedLinePainter(
                    color: AppColors.secondaryText,
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
                        coupon.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (coupon.validForExisting ?? false)
                            ? S.of(context).existing_customers_discount
                            : (coupon.validForNew ?? false)
                                ? S.of(context).new_customers_discount
                                : S.of(context).specific_items_discount,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate.isNotEmpty
                            ? '${S.of(context).valid_until} $formattedDate'
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

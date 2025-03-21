import 'package:deals/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/coupon_ticket/ticket_container.dart';
import '../../../../../core/widgets/coupon_ticket/rect_ticket_clipper.dart';
import '../../../../../core/widgets/coupon_ticket/dashed_line_painter.dart';

/// A specialized coupon widget that uses [TicketContainer].
/// This widget takes coupon-related data and uses the ticket container to display it.
/// The dashed line is drawn after the leading widget to create a more cohesive design.
class HomeCouponTicket extends StatelessWidget {
  final String title;
  final String code;
  final num? discountValue;
  final String? imageUrl;
  final DateTime? expiryDate;

  /// Sizing
  final double? width;
  final double? height;

  /// Callback for the trailing icon button
  final VoidCallback? onPressed;

  const HomeCouponTicket({
    super.key,
    required this.title,
    required this.code,
    this.discountValue,
    this.imageUrl,
    this.expiryDate,
    this.width,
    this.height = 120,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TicketContainer(
      holeRadius: 16,
      dashedLinePainter: const DashedLinePainter(
        dashHeight: 8,
        dashSpace: 4,
        strokeWidth: 2,
        color: Colors.black,
      ),
      centerLine: true, // places the dashed line between leading & child
      spacing: 25,
      width: width,
      height: height,
      leading: _buildLeadingImage(),
      child: _buildCouponInfo(),
    );
  }

  Widget _buildLeadingImage() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80),
      child: Image.network(
        imageUrl ?? '',
        fit: BoxFit.contain,
        errorBuilder: (ctx, error, stack) => Container(
          color: Colors.grey.shade200,
          child: Image.asset(AppImages.assetsImagesTest1),
        ),
      ),
    );
  }

  Widget _buildCouponInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isNotEmpty ? title : 'Placeholder Title',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            code.isNotEmpty ? code : 'Placeholder Code',
            style: const TextStyle(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (discountValue != null) ...[
            const SizedBox(height: 4),
            Text(
              '$discountValue% OFF',
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            expiryDate != null
                ? 'Valid until ${expiryDate!.toIso8601String().split("T")[0]}'
                : 'Valid until ...',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

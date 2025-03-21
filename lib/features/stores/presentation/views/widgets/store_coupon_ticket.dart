import 'package:deals/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/coupon_ticket/ticket_container.dart';
import '../../../../../core/widgets/coupon_ticket/rect_ticket_clipper.dart';
import '../../../../../core/widgets/coupon_ticket/dashed_line_painter.dart';

/// A specialized coupon widget that uses [TicketContainer].
/// Here we accept coupon-related data.
class StoreCouponTicket extends StatelessWidget {
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

  const StoreCouponTicket({
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
      clipper: const RectTicketClipper(holeRadius: 16),
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
      leading: _buildLeadingContent(),
      // trailing: IconButton(
      //   icon: const Icon(Icons.chevron_right),
      //   onPressed: onPressed,
      // ),
      child: _buildCouponInfo(),
    );
  }

  Widget _buildLeadingContent() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          SizedBox(
            width: 187,
            child: Text(
              'Extra discount to 10%',
              style: TextStyle(
                color: const Color(0xFF1D241F),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                SizedBox(
                  width: 187,
                  child: Text(
                    'offer might end before the specialized date',
                    style: TextStyle(
                      color: const Color(0xFF1D241F),
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                SizedBox(
                  width: 187,
                  child: Text(
                    'applied only if you purchase above 600\$',
                    style: TextStyle(
                      color: const Color(0xFF1D241F),
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

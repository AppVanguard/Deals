// coupon_placeholder_ticket.dart
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/rect_ticket_clipper.dart';

class CouponPlaceholderTicket extends StatelessWidget {
  const CouponPlaceholderTicket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.8;
    const cardHeight = 116.0;

    return Skeletonizer(
      enabled: true,
      child: PhysicalShape(
        elevation: 4,
        shadowColor: Colors.black54,
        color: Colors.grey.shade300,
        clipper: RectTicketClipper(holeRadius: 14),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
        ),
      ),
    );
  }
}

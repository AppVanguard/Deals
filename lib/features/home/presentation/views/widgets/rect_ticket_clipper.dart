import 'package:flutter/material.dart';

class RectTicketClipper extends CustomClipper<Path> {
  final double holeRadius;

  const RectTicketClipper({this.holeRadius = 14.0});

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final centerY = h / 2;
    final topHoleY = centerY - holeRadius;
    final bottomHoleY = centerY + holeRadius;

    final path = Path();

    // Move across top edge
    path.moveTo(0, 0);
    path.lineTo(w, 0);

    // Right side hole => arcs inward
    path.lineTo(w, topHoleY);
    path.arcToPoint(
      Offset(w, bottomHoleY),
      radius: Radius.circular(holeRadius),
      clockwise: true,
    );
    path.lineTo(w, h);

    // bottom edge left
    path.lineTo(0, h);

    // left side hole => arcs inward
    path.lineTo(0, bottomHoleY);
    path.arcToPoint(
      Offset(0, topHoleY),
      radius: Radius.circular(holeRadius),
      clockwise: true,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(RectTicketClipper oldClipper) =>
      holeRadius != oldClipper.holeRadius;
}

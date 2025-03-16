import 'package:flutter/material.dart';

/// A custom clipper that creates circle "holes" on the left & right edges,
/// giving a classic "ticket" shape.
class RectTicketClipper extends CustomClipper<Path> {
  final double holeRadius;

  const RectTicketClipper({this.holeRadius = 14.0});

  @override
  Path getClip(Size size) {
    final rectPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final centerY = size.height / 2;

    // Left hole
    final leftHoleRect = Rect.fromCircle(
      center: Offset(0, centerY),
      radius: holeRadius,
    );

    // Right hole
    final rightHoleRect = Rect.fromCircle(
      center: Offset(size.width, centerY),
      radius: holeRadius,
    );

    final holesPath = Path()
      ..addOval(leftHoleRect)
      ..addOval(rightHoleRect);

    // Subtract the holes from the rectangle
    return Path.combine(PathOperation.difference, rectPath, holesPath);
  }

  @override
  bool shouldReclip(RectTicketClipper oldClipper) {
    return holeRadius != oldClipper.holeRadius;
  }
}

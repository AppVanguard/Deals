import 'package:flutter/material.dart';

/// A [CustomClipper] that creates a classic "ticket" shape by cutting out
/// circular holes on the left/right edges (horizontal) or top/bottom edges (vertical).
///
/// The [holeRadius] controls how large each circular cutout is.
/// The [axis] determines whether we cut holes horizontally or vertically.
class RectTicketClipper extends CustomClipper<Path> {
  /// The radius of each circular "hole" cut out.
  final double holeRadius;

  /// Whether the ticket is horizontal (left/right holes) or vertical (top/bottom holes).
  final Axis axis;

  const RectTicketClipper({
    this.holeRadius = 14.0,
    this.axis = Axis.horizontal,
  });

  @override
  Path getClip(Size size) {
    final rectPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holesPath = Path();

    if (axis == Axis.horizontal) {
      // Left/right holes
      final centerY = size.height / 2;
      final leftHoleRect = Rect.fromCircle(
        center: Offset(0, centerY),
        radius: holeRadius,
      );
      final rightHoleRect = Rect.fromCircle(
        center: Offset(size.width, centerY),
        radius: holeRadius,
      );
      holesPath
        ..addOval(leftHoleRect)
        ..addOval(rightHoleRect);
    } else {
      // Top/bottom holes
      final centerX = size.width / 2;
      final topHoleRect = Rect.fromCircle(
        center: Offset(centerX, 0),
        radius: holeRadius,
      );
      final bottomHoleRect = Rect.fromCircle(
        center: Offset(centerX, size.height),
        radius: holeRadius,
      );
      holesPath
        ..addOval(topHoleRect)
        ..addOval(bottomHoleRect);
    }

    // Subtract the holes from the rectangle
    return Path.combine(PathOperation.difference, rectPath, holesPath);
  }

  @override
  bool shouldReclip(covariant RectTicketClipper oldClipper) {
    return holeRadius != oldClipper.holeRadius || axis != oldClipper.axis;
  }
}

import 'package:flutter/material.dart';

/// A [CustomClipper] that creates a classic "ticket" shape by cutting out
/// circular holes on the left and right edges of a rectangle.
///
/// The [holeRadius] controls how large each circular cutout is.
/// The clip is performed in [getClip], and the final shape is returned.
class RectTicketClipper extends CustomClipper<Path> {
  /// The radius of each circular "hole" cut out on the left and right edges.
  final double holeRadius;

  /// Creates a new [RectTicketClipper] with the given [holeRadius].
  const RectTicketClipper({this.holeRadius = 14.0});

  @override
  Path getClip(Size size) {
    // Start with a full rectangle that covers the entire size.
    final rectPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final centerY = size.height / 2;

    // Create circular holes (ovals) on the left and right edges.
    final leftHoleRect = Rect.fromCircle(
      center: Offset(0, centerY),
      radius: holeRadius,
    );
    final rightHoleRect = Rect.fromCircle(
      center: Offset(size.width, centerY),
      radius: holeRadius,
    );

    // Add both holes to a path.
    final holesPath = Path()
      ..addOval(leftHoleRect)
      ..addOval(rightHoleRect);

    // Subtract the holes from the original rectangle to get the final ticket shape.
    return Path.combine(PathOperation.difference, rectPath, holesPath);
  }

  @override
  bool shouldReclip(RectTicketClipper oldClipper) {
    // Reclip only if the holeRadius has changed.
    return holeRadius != oldClipper.holeRadius;
  }
}

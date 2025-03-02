import 'package:flutter/material.dart';

class RectTicketClipper extends CustomClipper<Path> {
  final double holeRadius;

  const RectTicketClipper({this.holeRadius = 14.0});

  @override
  Path getClip(Size size) {
    // Full rectangle covering the entire widget
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rectPath = Path()..addRect(rect);

    // Define the left and right holes as ovals (circles)
    final centerY = size.height / 2;
    final leftHoleRect =
        Rect.fromCircle(center: Offset(0, centerY), radius: holeRadius);
    final rightHoleRect = Rect.fromCircle(
        center: Offset(size.width, centerY), radius: holeRadius);

    final holesPath = Path()
      ..addOval(leftHoleRect)
      ..addOval(rightHoleRect);

    // Subtract the holes from the full rectangle
    return Path.combine(PathOperation.difference, rectPath, holesPath);
  }

  @override
  bool shouldReclip(covariant RectTicketClipper oldClipper) =>
      holeRadius != oldClipper.holeRadius;
}

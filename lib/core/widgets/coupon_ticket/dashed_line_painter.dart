import 'package:flutter/material.dart';

/// Draws a dashed line (vertical or horizontal).
class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double dashSpace;
  final double strokeWidth;

  /// Whether the line is vertical or horizontal.
  final Axis axis;

  const DashedLinePainter({
    this.color = Colors.grey,
    this.dashHeight = 5,
    this.dashSpace = 3,
    this.strokeWidth = 1,
    this.axis = Axis.vertical,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    if (axis == Axis.vertical) {
      // Vertical dashed line
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(0, startY),
          Offset(0, startY + dashHeight),
          paint,
        );
        startY += dashHeight + dashSpace;
      }
    } else {
      // Horizontal dashed line
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, 0),
          Offset(startX + dashHeight, 0),
          paint,
        );
        startX += dashHeight + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

/// A [CustomPainter] that draws a dashed line either vertically or horizontally,
/// depending on the provided [axis].
///
/// The dash pattern is determined by [dashHeight], [dashSpace], and [strokeWidth].
/// - [dashHeight] is the length of each dash.
/// - [dashSpace] is the space between dashes.
/// - [strokeWidth] controls the thickness of the dashes.
/// - [color] sets the color of the dashed line.
///
/// When [axis] is [Axis.vertical], it draws a vertical dashed line from top to bottom.
/// When [axis] is [Axis.horizontal], it draws a horizontal dashed line from left to right.
class DashedLinePainter extends CustomPainter {
  /// The color of the dashed line.
  final Color color;

  /// The length of each individual dash.
  final double dashHeight;

  /// The space between consecutive dashes.
  final double dashSpace;

  /// The thickness of the dashed line.
  final double strokeWidth;

  /// Whether the line is drawn vertically or horizontally.
  final Axis axis;

  /// Creates a new [DashedLinePainter] with the given configuration.
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
      // Draw a vertical dashed line
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
      // Draw a horizontal dashed line
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

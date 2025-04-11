import 'package:flutter/material.dart';

/// A [CustomPainter] that draws a dashed line in either [Axis.horizontal]
/// or [Axis.vertical].
///
/// - [dashHeight] is the length of each dash.
/// - [dashSpace] is the space between dashes.
/// - [strokeWidth] is the thickness of the dashes.
/// - [axis] chooses horizontal vs. vertical line.
class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double dashSpace;
  final double strokeWidth;
  final Axis axis;

  const DashedLinePainter({
    this.color = Colors.grey,
    this.dashHeight = 5,
    this.dashSpace = 3,
    this.strokeWidth = 1,
    this.axis = Axis.vertical,
  });

  /// Handy helper to clone with a new axis but same style.
  DashedLinePainter copyWith({
    Color? color,
    double? dashHeight,
    double? dashSpace,
    double? strokeWidth,
    Axis? axis,
  }) {
    return DashedLinePainter(
      color: color ?? this.color,
      dashHeight: dashHeight ?? this.dashHeight,
      dashSpace: dashSpace ?? this.dashSpace,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      axis: axis ?? this.axis,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    if (axis == Axis.vertical) {
      double startY = 0;
      while (startY < size.height) {
        final endY = (startY + dashHeight).clamp(0, size.height).toDouble();
        canvas.drawLine(
          Offset(0, startY),
          Offset(0, endY),
          paint,
        );
        startY += dashHeight + dashSpace;
      }
    } else {
      // axis == Axis.horizontal
      double startX = 0;
      while (startX < size.width) {
        final endX = (startX + dashHeight).clamp(0, size.width).toDouble();
        canvas.drawLine(
          Offset(startX, 0),
          Offset(endX, 0),
          paint,
        );
        startX += dashHeight + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) {
    return color != oldDelegate.color ||
        dashHeight != oldDelegate.dashHeight ||
        dashSpace != oldDelegate.dashSpace ||
        strokeWidth != oldDelegate.strokeWidth ||
        axis != oldDelegate.axis;
  }
}

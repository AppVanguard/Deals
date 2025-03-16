import 'package:flutter/material.dart';

/// A generic container that clips itself using a provided clipper (e.g. RectTicketClipper),
/// optionally shows a dashed line, and arranges leading, child, trailing in either
/// a horizontal row or vertical column.
class TicketContainer extends StatelessWidget {
  final CustomClipper<Path> clipper;
  final double elevation;
  final Color backgroundColor;

  /// Optional dashed line painter. If null, no line is drawn.
  final CustomPainter? dashedLinePainter;

  /// If `true`, place the dashed line between the leading and the child.
  /// If `false`, place the line after the child.
  final bool centerLine;

  /// Leading widget (e.g., brand logo).
  final Widget? leading;

  /// Trailing widget (e.g., an icon button).
  final Widget? trailing;

  /// Main content in the middle.
  final Widget? child;

  /// `true` for a horizontal row layout, `false` for a vertical column layout.
  final bool horizontalLayout;

  /// Spacing between the elements (leading, line, child, trailing).
  final double spacing;

  /// Optional width & height. If not provided, it tries to size to content.
  final double? width;
  final double? height;

  const TicketContainer({
    super.key,
    required this.clipper,
    this.elevation = 4.0,
    this.backgroundColor = Colors.white,
    this.dashedLinePainter,
    this.centerLine = false,
    this.leading,
    this.trailing,
    this.child,
    this.horizontalLayout = true,
    this.spacing = 12.0,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      clipper: clipper,
      clipBehavior: Clip.antiAlias,
      color: backgroundColor,
      elevation: elevation,
      child: SizedBox(
        width: width,
        height: height,
        child: _buildLayout(),
      ),
    );
  }

  Widget _buildLayout() {
    if (horizontalLayout) {
      return Row(
        children: [
          if (leading != null) ...[
            SizedBox(width: spacing),
            leading!,
            SizedBox(width: spacing),
          ],
          // If we have a dashedLinePainter and centerLine == true, place the line here
          if (dashedLinePainter != null && centerLine) ...[
            // Give the line an explicit height & vertical padding
            SizedBox(
              height: height ??
                  80, // match or approximate the ticket's total height
              width: 1, // thin line
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CustomPaint(painter: dashedLinePainter),
              ),
            ),
            SizedBox(width: spacing),
          ],
          // The main child
          if (child != null) Expanded(child: child!),
          // If we have a dashedLinePainter and centerLine == false, place the line here
          if (dashedLinePainter != null && !centerLine) ...[
            SizedBox(width: spacing),
            SizedBox(
              height: height ?? 80,
              width: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomPaint(painter: dashedLinePainter),
              ),
            ),
          ],
          if (trailing != null) ...[
            SizedBox(width: spacing),
            trailing!,
          ],
        ],
      );
    } else {
      // Vertical layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(height: spacing),
          ],
          if (dashedLinePainter != null && centerLine) ...[
            SizedBox(
              height: 1,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomPaint(painter: dashedLinePainter),
              ),
            ),
            SizedBox(height: spacing),
          ],
          if (child != null) Expanded(child: child!),
          if (dashedLinePainter != null && !centerLine) ...[
            SizedBox(height: spacing),
            SizedBox(
              height: 1,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomPaint(painter: dashedLinePainter),
              ),
            ),
          ],
          if (trailing != null) ...[
            SizedBox(height: spacing),
            trailing!,
          ],
        ],
      );
    }
  }
}

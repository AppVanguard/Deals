import 'package:flutter/material.dart';

/// A generic container widget that applies a "ticket" shape via a [CustomClipper],
/// optionally draws a dashed line, and arranges its [leading], [child], and [trailing]
/// widgets in either a horizontal row or vertical column layout.
///
/// This widget uses [PhysicalShape] to apply an elevation and clip behavior,
/// allowing you to create coupon-like or ticket-like UIs with "holes" on the sides.
class TicketContainer extends StatelessWidget {
  /// A [CustomClipper<Path>] that defines the ticket shape. For example,
  /// you can use [RectTicketClipper] to clip holes on the left and right edges.
  final CustomClipper<Path> clipper;

  /// The elevation of the resulting [PhysicalShape].
  /// A higher elevation value increases the drop shadow beneath the ticket.
  final double elevation;

  /// The background color of the ticket container.
  final Color backgroundColor;

  /// An optional dashed line painter, typically a [DashedLinePainter].
  /// If null, no dashed line is drawn.
  final CustomPainter? dashedLinePainter;

  /// If `true`, the dashed line (when present) is placed between the [leading] and [child].
  /// If `false`, the line is placed after the [child] (before the [trailing]).
  final bool centerLine;

  /// An optional widget placed at the start (left in horizontal layout, top in vertical layout).
  /// Commonly used for a brand logo or icon.
  final Widget? leading;

  /// An optional widget placed at the end (right in horizontal layout, bottom in vertical layout).
  /// Often used for an action icon (e.g., arrow or button).
  final Widget? trailing;

  /// The main content widget, typically displayed between the [leading] and [trailing].
  final Widget? child;

  /// Determines whether the layout is a horizontal [Row] (`true`) or vertical [Column] (`false`).
  final bool horizontalLayout;

  /// Spacing between the elements (leading, dashed line, child, trailing).
  final double spacing;

  /// Optional width for the entire ticket container. If null, it tries to size to its content.
  final double? width;

  /// Optional height for the entire ticket container. If null, it tries to size to its content.
  final double? height;

  /// Creates a [TicketContainer] that clips its content to a ticket shape, optionally
  /// drawing a dashed line and arranging [leading], [child], and [trailing].
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

  /// Builds either a horizontal [Row] or a vertical [Column],
  /// placing [leading], an optional dashed line, [child], another optional line, and [trailing].
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

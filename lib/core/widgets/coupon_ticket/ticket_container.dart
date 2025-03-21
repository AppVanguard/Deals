import 'package:flutter/material.dart';

/// A generic container widget that applies a "ticket" shape via a [CustomClipper],
/// optionally draws a dashed line, and arranges its [leading], [child], and [trailing]
/// widgets in either a horizontal row or vertical column layout.
/// This widget now supports responsive behavior by adjusting spacing and widget sizes
/// based on the screen width.
class TicketContainer extends StatelessWidget {
  /// A [CustomClipper<Path>] that defines the ticket shape. For example,
  /// you can use [RectTicketClipper] to clip holes on the left and right edges.
  final CustomClipper<Path> clipper;

  /// The elevation of the resulting [PhysicalShape].
  final double elevation;

  /// The background color of the ticket container.
  final Color backgroundColor;

  /// An optional dashed line painter, typically a [DashedLinePainter].
  final CustomPainter? dashedLinePainter;

  /// If `true`, the dashed line (when present) is placed between the [leading] and [child].
  final bool centerLine;

  /// An optional widget placed at the start (left in horizontal layout, top in vertical layout).
  final Widget? leading;

  /// An optional widget placed at the end (right in horizontal layout, bottom in vertical layout).
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
        width: width ??
            MediaQuery.of(context).size.width * 0.8, // Responsive width
        height: height ??
            MediaQuery.of(context).size.height * 0.15, // Responsive height
        child: _buildLayout(context),
      ),
    );
  }

  /// Builds either a horizontal [Row] or a vertical [Column], placing [leading],
  /// an optional dashed line, [child], and [trailing] with flexible spacing.
  Widget _buildLayout(BuildContext context) {
    double adjustedSpacing = spacing;

    if (MediaQuery.of(context).size.width < 400) {
      adjustedSpacing =
          8.0; // Reduced spacing on small screens for better layout
    }

    if (horizontalLayout) {
      return Row(
        children: [
          if (leading != null) ...[
            SizedBox(width: adjustedSpacing),
            leading!,
            SizedBox(width: adjustedSpacing),
          ],
          if (dashedLinePainter != null && centerLine) ...[
            SizedBox(
              height: height ?? 80,
              width: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CustomPaint(painter: dashedLinePainter),
              ),
            ),
            SizedBox(width: adjustedSpacing),
          ],
          if (child != null) Expanded(child: child!),
          if (dashedLinePainter != null && !centerLine) ...[
            SizedBox(width: adjustedSpacing),
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
            SizedBox(width: adjustedSpacing),
            trailing!,
            SizedBox(width: adjustedSpacing),
          ],
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(height: adjustedSpacing),
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
            SizedBox(height: adjustedSpacing),
          ],
          if (child != null) Expanded(child: child!),
          if (dashedLinePainter != null && !centerLine) ...[
            SizedBox(height: adjustedSpacing),
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
            SizedBox(height: adjustedSpacing),
            trailing!,
          ],
        ],
      );
    }
  }
}

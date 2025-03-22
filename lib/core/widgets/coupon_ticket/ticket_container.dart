import 'package:flutter/material.dart';
import 'rect_ticket_clipper.dart';
import 'dashed_line_painter.dart';

/// A ticket-shaped container with optional dashed divider,
/// supporting horizontal or vertical layout.
class TicketContainer extends StatelessWidget {
  /// Ticket material elevation (shadow).
  final double elevation;

  /// Ticket background color.
  final Color backgroundColor;

  /// Optional dashed line painter (e.g. [DashedLinePainter]).
  final CustomPainter? dashedLinePainter;

  /// Place the dashed line between [leading] and [child] if true,
  /// otherwise between [child] and [trailing].
  final bool centerLine;

  /// Leading widget (left side in horizontal, top in vertical).
  final Widget? leading;

  /// Trailing widget (right side in horizontal, bottom in vertical).
  final Widget? trailing;

  /// Main child placed between leading and trailing.
  final Widget? child;

  /// Whether this is a horizontal coupon (left/right holes) or vertical coupon (top/bottom holes).
  final bool horizontalLayout;

  /// Spacing between elements in the ticket.
  final double spacing;

  /// Optional fixed width. If null, fits content horizontally (or parent constraints).
  final double? width;

  /// Optional fixed height. If null, fits content vertically (or parent constraints).
  final double? height;

  /// Radius of the circular ticket holes.
  final double holeRadius;

  /// Tap callback.
  final VoidCallback? onTap;

  const TicketContainer({
    super.key,
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
    this.holeRadius = 14.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PhysicalShape(
        clipper: RectTicketClipper(
          holeRadius: holeRadius,
          axis: horizontalLayout ? Axis.horizontal : Axis.vertical,
        ),
        clipBehavior: Clip.antiAlias,
        color: backgroundColor,
        elevation: elevation,
        // If width/height are not provided, let layout grow/shrink by content.
        child: (width == null && height == null)
            ? _buildLayout(context)
            : SizedBox(
                width: width,
                height: height,
                child: _buildLayout(context),
              ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    double adjustedSpacing = spacing;
    if (MediaQuery.of(context).size.width < 400) {
      adjustedSpacing = 8.0; // Example of minor responsiveness
    }

    if (horizontalLayout) {
      // -------------------------------------
      // HORIZONTAL TICKET => vertical dashed line
      // Use IntrinsicHeight + crossAxisAlignment.stretch so the
      // dashed line can fill the full ticket height.
      // -------------------------------------
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (leading != null) ...[
              SizedBox(width: holeRadius),
              SizedBox(width: adjustedSpacing),
              leading!,
              SizedBox(width: adjustedSpacing),
            ],
            if (dashedLinePainter != null && centerLine) ...[
              _buildVerticalDashedLine(padding: 16.0),
              SizedBox(width: adjustedSpacing),
            ],
            if (child != null) ...[
              // Optionally wrap in Expanded if you want to fill horizontally.
              // Otherwise, omit Expanded to let it shrink-wrap.
              Expanded(child: child!),
              SizedBox(width: adjustedSpacing),
            ],
            if (dashedLinePainter != null && !centerLine) ...[
              SizedBox(width: adjustedSpacing),
              _buildVerticalDashedLine(padding: 8.0),
            ],
            if (trailing != null) ...[
              SizedBox(width: adjustedSpacing),
              trailing!,
              SizedBox(width: holeRadius),
              SizedBox(width: adjustedSpacing),
            ],
          ],
        ),
      );
    } else {
      // -------------------------------------
      // VERTICAL TICKET => horizontal dashed line
      // A simple Column with crossAxisAlignment.stretch suffices.
      // -------------------------------------
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (leading != null) ...[
            SizedBox(height: holeRadius),
            SizedBox(height: adjustedSpacing),
            leading!,
            SizedBox(height: adjustedSpacing),
          ],
          if (dashedLinePainter != null && centerLine) ...[
            _buildHorizontalDashedLine(padding: 8.0),
            SizedBox(height: adjustedSpacing),
          ],
          if (child != null) ...[
            child!,
            SizedBox(height: adjustedSpacing),
          ],
          if (dashedLinePainter != null && !centerLine) ...[
            SizedBox(height: adjustedSpacing),
            _buildHorizontalDashedLine(padding: 8.0),
          ],
          if (trailing != null) ...[
            SizedBox(height: adjustedSpacing),
            trailing!,
            SizedBox(height: holeRadius),
            SizedBox(height: adjustedSpacing),
          ],
        ],
      );
    }
  }

  /// Builds a vertical dashed line (1dp wide) that stretches to fill
  /// the parent's height. We rely on crossAxisAlignment.stretch + IntrinsicHeight.
  Widget _buildVerticalDashedLine({double padding = 0}) {
    if (dashedLinePainter == null) return const SizedBox.shrink();

    // If we can cast to DashedLinePainter, override axis. Otherwise, use original.
    final forcedPainter = (dashedLinePainter is DashedLinePainter)
        ? (dashedLinePainter as DashedLinePainter).copyWith(axis: Axis.vertical)
        : dashedLinePainter;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: SizedBox(
        // 1dp wide line, the height is stretched by crossAxisAlignment.stretch
        width: 1,
        child: CustomPaint(painter: forcedPainter),
      ),
    );
  }

  /// Builds a horizontal dashed line (1dp high) that stretches across
  /// the parent's width.
  Widget _buildHorizontalDashedLine({double padding = 0}) {
    if (dashedLinePainter == null) return const SizedBox.shrink();

    final forcedPainter = (dashedLinePainter is DashedLinePainter)
        ? (dashedLinePainter as DashedLinePainter)
            .copyWith(axis: Axis.horizontal)
        : dashedLinePainter;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: SizedBox(
        width: double.infinity,
        height: 1,
        child: CustomPaint(painter: forcedPainter),
      ),
    );
  }
}

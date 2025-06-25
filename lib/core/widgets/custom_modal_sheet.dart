import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

/// Helper widget and static [show] method for displaying a styled modal sheet.
///
/// Provides an icon (or SVG), a message, and an action button. Use the static
/// [show] convenience method to present it from anywhere.

class CustomModalSheet extends StatelessWidget {
  /// Main message displayed inside the sheet.
  final String message;

  /// Label for the action button.
  final String buttonText;

  /// Callback executed when the user taps the action button.
  final VoidCallback onTap;

  /// Whether the sheet can be dismissed by tapping outside of it.
  final bool isDismissible;

  /// Rounded corner radius of the top of the sheet.
  final double borderRadius;

  /// Height of the sheet.
  final double height;

  /// Optional icon displayed above the message when no [svgPicture] is given.
  final IconData? icon;

  /// Color for the [icon].
  final Color iconColor;

  /// Size of the [icon].
  final double iconSize;

  /// Alternative to [icon] for vector assets.
  final SvgPicture? svgPicture; // Add SVG support

  /// Text style applied to the message.
  final TextStyle? messageStyle;

  /// Background color of the sheet container.
  final Color backgroundColor;

  /// Whether dragging down can dismiss the sheet.
  final bool? enableDrag;
  const CustomModalSheet({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onTap,
    this.isDismissible = false,
    this.borderRadius = 36.0,
    this.height = 200,
    this.icon = Icons.check_circle,
    this.iconColor = Colors.green,
    this.iconSize = 48,
    this.svgPicture, // Default is null, so it’s optional
    this.messageStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    this.backgroundColor = Colors.white,
    this.enableDrag = true,
  });

  static Future<void> show(
    BuildContext context, {
    required String message,
    required String buttonText,
    required VoidCallback onTap,
    bool isDismissible = false,
    double borderRadius = 36.0,
    double height = 250,
    IconData? icon = Icons.check_circle,
    Color iconColor = Colors.green,
    double iconSize = 48,
    SvgPicture? svgPicture, // Accept SVG
    TextStyle? messageStyle,
    Color backgroundColor = Colors.white,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      enableDrag: enableDrag,
      context: context,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      builder: (context) {
        return CustomModalSheet(
          message: message,
          buttonText: buttonText,
          onTap: onTap,
          isDismissible: isDismissible,
          borderRadius: borderRadius,
          height: height,
          icon: icon,
          iconColor: iconColor,
          iconSize: iconSize,
          svgPicture: svgPicture, // Pass the SVG if provided
          messageStyle: messageStyle ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          backgroundColor: backgroundColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (svgPicture != null) // If an SVG is provided, show it
            svgPicture!
          else if (icon != null) // Otherwise, show an Icon
            Icon(icon, color: iconColor, size: iconSize),
          const SizedBox(height: 8),
          Text(message, style: messageStyle),
          const SizedBox(height: 8),
          CustomButton(
            buttonRadius: 32,
            width: double.infinity,
            onPressed: () {
              context.pop();
              onTap();
            },
            text: buttonText,
          )
        ],
      ),
    );
  }
}

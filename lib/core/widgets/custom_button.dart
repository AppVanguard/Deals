import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

/// A reusable rounded button with optional loading indicator.
///
/// The [CustomButton] displays a text label and triggers the provided
/// [onPressed] callback when tapped. It can be customized with optional width,
/// border radius, button and text colors, and a loading state that disables the
/// button and shows a small progress indicator next to the text.

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.buttonRadius = 16,
    this.buttonColor,
    this.textColor,
    this.isLoading = false, // NEW
  });

  /// Callback invoked when the button is tapped.
  final VoidCallback onPressed;

  /// Text displayed inside the button.
  final String text;

  /// Optional fixed width for the button.
  final double? width;

  /// Radius of the button's rounded corners.
  final double? buttonRadius;

  /// Background color of the button.
  final Color? buttonColor;

  /// Color of the text inside the button.
  final Color? textColor;

  /// When true a progress indicator is shown and the button is disabled.
  final bool isLoading; // NEW

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius!),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: AppTextStyles.bold16
                          .copyWith(color: textColor ?? Colors.white),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            textColor ?? Colors.white),
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: AppTextStyles.bold16
                      .copyWith(color: textColor ?? Colors.white),
                ),
        ),
      ),
    );
  }
}

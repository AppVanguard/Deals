import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomErrorScreen extends StatelessWidget {
  /// Main title to display. Defaults to "Something Went Wrong".
  final String title;

  /// Primary error message. Defaults to a generic message.
  final String message;

  /// Optional error details. Defaults to an empty string.
  final String errorDetails;

  /// Callback to invoke when the user taps the retry button.
  final VoidCallback onRetry;

  /// Text for the retry button. Defaults to "Retry".
  final String retryButtonText;

  /// Optional custom error illustration widget.
  final Widget? errorIllustration;

  /// Optional Lottie animation asset path for error illustration.
  final String? lottieAnimationAsset;

  /// Optional footer widget. Defaults to null.
  final Widget? footer;

  /// Optional background gradient colors.
  final List<Color> gradientColors;

  /// Optional background color if gradient is not desired.
  final Color backgroundColor;

  const CustomErrorScreen({
    super.key,
    this.title = 'Something Went Wrong',
    this.message = 'An unexpected error has occurred. Please try again later.',
    this.errorDetails = '',
    required this.onRetry,
    this.retryButtonText = 'Retry',
    this.errorIllustration,
    this.lottieAnimationAsset,
    this.footer,
    this.gradientColors = const [Color(0xFF2196F3), Color(0xFF64B5F6)],
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the error illustration widget.
    Widget illustration = errorIllustration ??
        const Icon(
          Icons.error_outline,
          size: 80,
          color: Colors.blueAccent,
        );

    // If a Lottie asset is provided, override the illustration.
    if (lottieAnimationAsset != null) {
      illustration = SizedBox(
        height: 300,
        child: Lottie.asset(lottieAnimationAsset!, repeat: true),
      );
    }

    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: gradientColors.isNotEmpty
            ? LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              // vertical: 32.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                illustration,
                const SizedBox(height: 24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold14,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold14,
                ),
                if (errorDetails.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorDetails,
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.bold14.copyWith(color: Colors.redAccent),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    width: double.infinity,
                    text: 'Retry',
                    onPressed: onRetry,
                  ),
                ),
                if (footer != null) ...[
                  const SizedBox(height: 16),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

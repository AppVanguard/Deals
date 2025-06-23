import 'package:deals/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomErrorScreen extends StatelessWidget {
  /// Main title to display. Defaults to "Something Went Wrong".
  final Widget title;

  /// Primary error message. Defaults to a generic message.
  final Widget message;

  /// Optional error details. Defaults to an empty string.
  final Widget? errorDetails;

  /// Whether to show the retry animation.
  final bool retryAnimation;

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

  /// Whether to wrap the widget in a Scaffold to take up the whole screen.
  final bool fullScreen;

  const CustomErrorScreen({
    super.key,
    this.retryAnimation = true,
    required this.title,
    required this.message,
    this.errorDetails,
    required this.onRetry,
    this.retryButtonText = "Retry",
    this.errorIllustration,
    this.lottieAnimationAsset,
    this.footer,
    this.gradientColors = const [Color(0xFF2196F3), Color(0xFF64B5F6)],
    this.backgroundColor = Colors.white,
    this.fullScreen = true,
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
        child: Lottie.asset(lottieAnimationAsset!, repeat: retryAnimation),
      );
    }

    final size = MediaQuery.of(context).size;

    final content = Container(
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
        child: Align(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                illustration,
                const SizedBox(height: 24),
                title,
                const SizedBox(height: 12),
                message,
                if (errorDetails != null) ...[
                  const SizedBox(height: 8),
                  errorDetails!,
                ],
                const SizedBox(height: 24),
                CustomButton(
                  width: double.infinity,
                  text: retryButtonText,
                  onPressed: onRetry,
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

    if (fullScreen) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: content,
      );
    }

    return content;
  }
}

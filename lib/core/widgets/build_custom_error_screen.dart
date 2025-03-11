import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_error_screen.dart';
import 'package:flutter/material.dart';

CustomErrorScreen buildCustomErrorScreen(
    {required BuildContext context, required void Function() onRetry}) {
  return CustomErrorScreen(
    title: 'Oops, something went wrong!',
    message:
        'We encountered an unexpected error while processing your request.',
    errorDetails: 'Error Code: 500 - Internal Server Error',
    onRetry: onRetry,
    retryButtonText: 'Try Again',
    // Optionally override the default error illustration
    errorIllustration: const Icon(
      Icons.cloud_off,
      size: 80,
      color: Colors.orangeAccent,
    ),
    // Optionally provide a Lottie animation (this overrides errorIllustration if provided)
    lottieAnimationAsset: 'assets/animations/error.json',
    // Customize the background gradient
    gradientColors: const [AppColors.background, AppColors.background],
    backgroundColor: AppColors.primary,
    // Optional footer widget
    footer: const Text(
      'If the issue persists, please contact our support team.',
      textAlign: TextAlign.center,
      style: AppTextStyles.regular16,
    ),
  );
}

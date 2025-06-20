import 'package:deals/constants.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_error_screen.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

CustomErrorScreen buildCustomErrorScreen({
  required BuildContext context,
  required void Function() onRetry,
  String? errorMessage,
}) {
  return CustomErrorScreen(
    retryAnimation: false,
    title: Text(
      errorMessage ?? S.of(context).SomethingWentWrongError,
      textAlign: TextAlign.center,
      style: AppTextStyles.bold14,
    ),
    message: Text(
      errorMessage ?? S.of(context).UnexpectedError,
      textAlign: TextAlign.center,
      style: AppTextStyles.bold14,
    ),
    errorDetails: errorMessage != null
        ? Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: AppTextStyles.bold14.copyWith(color: Colors.redAccent),
          )
        : null,
    onRetry: onRetry,
    retryButtonText: S.of(context).Retry,
    // Optionally override the default error illustration
    errorIllustration: const Icon(
      Icons.cloud_off,
      size: 80,
      color: Colors.orangeAccent,
    ),
    // Optionally provide a Lottie animation (this overrides errorIllustration if provided)
    lottieAnimationAsset: kErrorAnimation,
    // Customize the background gradient
    gradientColors: const [AppColors.background, AppColors.background],
    backgroundColor: AppColors.primary,
    // Optional footer widget
    footer: Text(
      S.of(context).ContactSupportForFailure,
      textAlign: TextAlign.center,
      style: AppTextStyles.regular16,
    ),
  );
}

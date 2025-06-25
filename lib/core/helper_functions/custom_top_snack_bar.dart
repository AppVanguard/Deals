import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

/// Shows an animated top snack bar styled as an error.
///
/// [message] is displayed inside the banner. Duration parameters control how
/// long the snackbar remains visible and how quickly it animates.
void customErrorTopSnackBar({
  required BuildContext context,
  required String message,
  Duration displayDuration = const Duration(milliseconds: 3000),
  Duration reverseAnimationDuration = const Duration(milliseconds: 550),
  Duration animationDuration = const Duration(milliseconds: 1200),
}) {
  return showTopSnackBar(
    animationDuration: animationDuration,
    reverseAnimationDuration: reverseAnimationDuration,
    displayDuration: animationDuration,
    Overlay.of(context),
    CustomSnackBar.error(
      message: message,
    ),
  );
}

/// Shows an animated top snack bar styled as success.
///
/// Shares the same parameters as [customErrorTopSnackBar].
void customSuccessTopSnackBar({
  required BuildContext context,
  required String message,
  Duration displayDuration = const Duration(milliseconds: 3000),
  Duration reverseAnimationDuration = const Duration(milliseconds: 550),
  Duration animationDuration = const Duration(milliseconds: 1200),
}) {
  return showTopSnackBar(
    animationDuration: animationDuration,
    reverseAnimationDuration: reverseAnimationDuration,
    displayDuration: animationDuration,
    Overlay.of(context),
    CustomSnackBar.success(
      message: message,
    ),
  );
}

void customInfoTopSnackBar({
  required BuildContext context,
  required String message,
  Duration displayDuration = const Duration(milliseconds: 3000),
  Duration reverseAnimationDuration = const Duration(milliseconds: 550),
  Duration animationDuration = const Duration(milliseconds: 1200),
}) {
  return showTopSnackBar(
    animationDuration: animationDuration,
    reverseAnimationDuration: reverseAnimationDuration,
    displayDuration: animationDuration,
    Overlay.of(context),
    CustomSnackBar.info(
      message: message,
    ),
  );
}

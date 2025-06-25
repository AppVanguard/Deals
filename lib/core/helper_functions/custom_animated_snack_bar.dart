import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

/// Displays a styled animated snack bar.
///
/// When [isMaterial] is true, the material design variant is used, otherwise a
/// rectangular snack bar is shown. The [type] controls the color scheme and icon
/// while [message] provides the text to display.
AnimatedSnackBar customAnimatedSnackBar(
    {bool isMaterial = false,
    required AnimatedSnackBarType type,
    required String message}) {
  if (isMaterial) {
    return AnimatedSnackBar.material(
      duration: const Duration(seconds: 3),
      message,
      type: type,
      // brightness: Brightness.light,
    );
  } else {
    return AnimatedSnackBar.rectangle(
      duration: const Duration(seconds: 3),
      'خطأ في التسجيل',
      message,
      type: type,
      brightness: Brightness.light,
    );
  }
}

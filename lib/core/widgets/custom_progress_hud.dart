import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// Wraps content with a modal progress indicator.
///
/// Displays a blocking loading spinner when [isLoading] is true. Useful for
/// showing a simple loading overlay during asynchronous operations.

class CustomProgressHud extends StatelessWidget {
  const CustomProgressHud(
      {super.key, required this.child, required this.isLoading});
  /// Widget displayed beneath the loading overlay.
  final Widget child;

  /// Whether the progress HUD should be shown.
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: child,
    );
  }
}

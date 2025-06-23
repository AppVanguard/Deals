import 'package:flutter/material.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/utils/app_colors.dart';

/// A stylized error message card used across the app when a full
/// screen error view isn't appropriate.
class ErrorMessageCard extends StatelessWidget {
  const ErrorMessageCard({
    super.key,
    required this.title,
    required this.message,
    this.details,
    this.onRetry,
    this.retryButtonText = 'Retry',
    this.buttonColor,
  });

  /// Short error title.
  final String title;

  /// Main descriptive message.
  final String message;

  /// Optional error details shown below the description.
  final String? details;

  /// Called when the retry button is tapped.
  final VoidCallback? onRetry;

  /// Text for the retry button.
  final String retryButtonText;

  /// Color of the retry button.
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            if (onRetry != null)
              CustomButton(
                width: double.infinity,
                text: retryButtonText,
                onPressed: onRetry!,
                buttonColor: buttonColor ?? AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

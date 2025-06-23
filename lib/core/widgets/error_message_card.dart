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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.redAccent),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.redAccent, size: 48),
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

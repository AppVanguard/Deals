import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

/// Small text widget used on auth screens for sign-in/sign-up switching.

class HaveOrNotAccount extends StatelessWidget {
  /// Creates an inline text with a tappable [action] portion.
  const HaveOrNotAccount({
    super.key,
    this.onTap,
    required this.question,
    required this.action,
  });

  /// Callback triggered when the action text is tapped.
  final void Function()? onTap;

  /// Leading question text, e.g. "Already have an account?".
  final String question;

  /// Action label, e.g. "Sign In".
  final String action;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: question,
              style: AppTextStyles.regular14.copyWith(
                color: AppColors.tertiaryText,
              )),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            text: action,
            style: AppTextStyles.bold14.copyWith(color: AppColors.primary),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

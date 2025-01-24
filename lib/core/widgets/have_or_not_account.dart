import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';

class HaveOrNotAccount extends StatelessWidget {
  const HaveOrNotAccount(
      {super.key, this.onTap, required this.question, required this.action});
  final void Function()? onTap;
  final String question, action;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: question,
              style: AppTextStyles.regular14.copyWith(
                color: const Color(0xFF949D9E),
              )),
          TextSpan(
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

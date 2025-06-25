import 'package:flutter/material.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

/// Horizontal divider with optional text for auth screens.

class AuthDivider extends StatelessWidget {
  /// Divider label displayed between the two horizontal lines.
  const AuthDivider({super.key, required this.text});

  /// Text placed in the middle of the divider.
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: kSpacing + 2,
        children: [
          const Expanded(
            child: Divider(
              color: Color(0xffdcdede),
            ),
          ),
          Text(
            text,
            style: AppTextStyles.regular14.copyWith(
              color: AppColors.text,
            ),
          ),
          const Expanded(
            child: Divider(
              color: Color(0xffdcdede),
            ),
          )
        ],
      ),
    );
  }
}

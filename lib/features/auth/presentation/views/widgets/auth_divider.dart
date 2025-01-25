import 'package:flutter/material.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: kSpacing + 2,
        children: [
          Expanded(
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
          Expanded(
            child: Divider(
              color: Color(0xffdcdede),
            ),
          )
        ],
      ),
    );
  }
}

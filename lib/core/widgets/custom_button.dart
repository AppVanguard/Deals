import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.buttonRadius = 16,
    this.buttonColor,
    this.textColor,
  });
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? buttonRadius;
  final Color? buttonColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: buttonColor ?? AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonRadius!))),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            style:
                AppTextStyles.bold16.copyWith(color: textColor ?? Colors.white),
            text,
          ),
        ),
      ),
    );
  }
}

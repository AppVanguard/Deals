// lib/core/widgets/custom_text_form_field.dart

import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.hasBorder = true,
    required this.textInputType,
    required this.label,
    required this.validator,
    this.suffixIcon,
    this.onSaved,
    this.obscureText = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.borderColor,
    this.initialValue,
    this.enabled = true,
    this.fillColor,
    this.textColor,
    this.textStyle,
    this.disabledFillColor, // ← NEW
    this.disabledTextColor, // ← NEW
  });

  final String hintText;
  final String label;
  final TextInputType textInputType;
  final String? Function(String?) validator;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Color? borderColor;
  final String? initialValue;
  final bool enabled;
  final Color? fillColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? disabledFillColor; // ← NEW
  final Color? disabledTextColor; // ← NEW
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    // choose background based on enabled/disabled
    final bgColor = enabled
        ? (fillColor ?? Colors.white)
        : (disabledFillColor ?? AppColors.secondaryText);

    // choose input text color
    final fgColor = enabled
        ? (textColor ?? AppColors.text)
        : (disabledTextColor ?? AppColors.lightGray);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.regular14.copyWith(color: AppColors.text)),
        const SizedBox(height: 4),
        TextFormField(
          enabled: enabled,
          initialValue: initialValue,
          keyboardType: textInputType,
          obscureText: obscureText,
          style: textStyle ?? AppTextStyles.regular14.copyWith(color: fgColor),
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            // only show hint when enabled
            hintText: enabled ? hintText : null,
            hintStyle: AppTextStyles.regular13
                .copyWith(color: const Color(0xFF949D9E)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: bgColor,
            border: hasBorder ? _buildBorder() : null,
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(isFocused: true),
            errorBorder: _buildBorder(color: Colors.red),
            focusedErrorBorder:
                _buildBorder(color: Colors.red, isFocused: true),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder({Color? color, bool isFocused = false}) {
    final c = color ?? borderColor ?? const Color(0xFFD7D9D9);
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c, width: isFocused ? 1.8 : 1.2),
    );
  }
}

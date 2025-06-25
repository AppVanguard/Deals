// lib/core/widgets/custom_text_form_field.dart

import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

/// A text form field with consistent styling used across the app.
///
/// [CustomTextFormField] wraps [TextFormField] and exposes common properties for
/// validation, appearance and event callbacks. It supports optional borders,
/// custom colors and disabled styling, making it suitable for multiple forms.

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

  /// Hint text shown when the field is empty.
  final String hintText;

  /// Label displayed above the field.
  final String label;

  /// Keyboard input type for the field.
  final TextInputType textInputType;

  /// Validation callback returning an error message if invalid.
  final String? Function(String?) validator;

  /// Optional suffix widget, e.g. an icon.
  final Widget? suffixIcon;

  /// Called when the form is saved.
  final void Function(String?)? onSaved;

  /// Whether the text should be obscured (for passwords).
  final bool obscureText;

  /// Called whenever the field value changes.
  final void Function(String)? onChanged;

  /// Called when the user submits from the keyboard.
  final void Function(String)? onFieldSubmitted;

  /// Border color when enabled/focused.
  final Color? borderColor;

  /// Initial text value.
  final String? initialValue;

  /// Whether the field is enabled.
  final bool enabled;

  /// Background color when enabled.
  final Color? fillColor;

  /// Text color when enabled.
  final Color? textColor;

  /// Custom text style (overrides [textColor]).
  final TextStyle? textStyle;

  /// Background color when disabled.
  final Color? disabledFillColor; // ← NEW

  /// Text color when disabled.
  final Color? disabledTextColor; // ← NEW

  /// Whether to draw an outline border.
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

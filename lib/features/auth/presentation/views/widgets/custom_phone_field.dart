import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

/// Wrapper around [IntlPhoneField] with consistent styling and callbacks.

class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    super.key,
    required this.label,
    this.initialCountryCode = 'EG', // NEW: default, but can be overridden
    this.initialValue, // NEW: to prefill the number
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
    this.validator,
    this.autovalidateMode,
  });

  /// Field label displayed above the input.
  final String label;

  /// Two-letter country code used as the initial value.
  final String initialCountryCode; // NEW

  /// Prefilled phone number string.
  final String? initialValue; // NEW

  /// Called whenever the number changes.
  final void Function(PhoneNumber)? onChanged;

  /// Called when the form is saved.
  final void Function(PhoneNumber?)? onSaved;

  /// Callback on submitting via the keyboard.
  final void Function(String)? onSubmitted;

  /// Validation callback for the phone value.
  final FutureOr<String?> Function(PhoneNumber?)? validator;

  /// Autovalidate mode passed to [IntlPhoneField].
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.regular14.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 4),
        IntlPhoneField(
          initialCountryCode: initialCountryCode, // use provided or default
          initialValue: initialValue, // pre-fill phone number
          autovalidateMode: autovalidateMode,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: onChanged,
          onSaved: onSaved,
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}

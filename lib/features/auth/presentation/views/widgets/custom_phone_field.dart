import 'dart:async';

import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    super.key,
    required this.label,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
    this.validator,
    this.autovalidateMode,
  });
  final String label;
  final void Function(PhoneNumber)? onChanged;
  final void Function(PhoneNumber?)? onSaved;
  final void Function(String)? onSubmitted;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.regular14.copyWith(color: AppColors.text),
          ),
          IntlPhoneField(
            autovalidateMode: autovalidateMode,
            validator: validator,
            decoration: InputDecoration(
              // labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 2),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            initialCountryCode: 'EG',
            onChanged: onChanged,
            onSaved: onSaved,
            onSubmitted: onSubmitted,
          ),
        ],
      ),
    );
  }
}

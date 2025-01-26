import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/generated/l10n.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,
    this.onSaved,
    this.obscureText = false,
    required this.label,
    required this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });
  final bool obscureText;
  final String hintText, label;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final String? Function(String?) validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.regular14.copyWith(color: AppColors.text),
          ),
          TextFormField(
            onFieldSubmitted: onFieldSubmitted,
            onChanged: onChanged,
            obscureText: obscureText,
            onSaved: onSaved,
            validator: validator,
            keyboardType: textInputType,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintStyle: AppTextStyles.regular13
                  .copyWith(color: const Color(0xff949d9e)),
              hintText: hintText,
              // filled: true,
              // fillColor: const Color(0xfff9fafa),
              border: buildBorder(),
              enabledBorder: buildBorder(),
              focusedBorder: buildBorder(),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        width: 1,
        // color: Color(0xffe6e9e9),
      ),
    );
  }
}

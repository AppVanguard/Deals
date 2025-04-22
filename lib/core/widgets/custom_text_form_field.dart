import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.textInputType,
    required this.label,
    required this.validator,
    this.suffixIcon,
    this.onSaved,
    this.obscureText = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.borderColor, // NEW
  });

  final bool obscureText;
  final String hintText, label;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final String? Function(String?) validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Color? borderColor; // NEW

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.regular14.copyWith(color: AppColors.text)),
        TextFormField(
          keyboardType: textInputType,
          obscureText: obscureText,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.regular13
                .copyWith(color: const Color(0xff949d9e)),
            suffixIcon: suffixIcon,
            border: _buildBorder(),
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
    final c = color ?? borderColor ?? const Color(0xffd7d9d9);
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c, width: isFocused ? 1.8 : 1.2),
    );
  }
}

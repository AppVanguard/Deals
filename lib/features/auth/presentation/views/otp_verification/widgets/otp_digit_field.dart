import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

/// Single input field for one OTP digit.
class OtpDigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isError;
  final bool hasValue;
  final bool showGlobalError;
  final ValueChanged<String> onChanged;
  final void Function(KeyEvent) onKey;

  const OtpDigitField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isError,
    required this.hasValue,
    required this.showGlobalError,
    required this.onChanged,
    required this.onKey,
  });

  OutlineInputBorder _border({bool focused = false}) {
    Color color;
    if (showGlobalError) {
      color = Colors.red;
    } else if (isError) {
      color = Colors.red;
    } else if (hasValue) {
      color = AppColors.primary;
    } else {
      color = Colors.grey.shade400;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: focused ? 2 : 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Focus(
        onKeyEvent: (node, event) {
          onKey(event);
          return KeyEventResult.ignored;
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          cursorHeight: 30,
          style: AppTextStyles.semiBold32,
          decoration: InputDecoration(
            counterText: '',
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(focused: true),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

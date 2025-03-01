import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

import 'package:deals/features/auth/presentation/views/widgets/custom_check_box.dart';
import 'package:deals/generated/l10n.dart';

class RememberPassword extends StatefulWidget {
  const RememberPassword({super.key, required this.onChecked, this.onTap});
  final ValueChanged<bool> onChecked;
  final void Function()? onTap;
  @override
  State<RememberPassword> createState() => _RememberPasswordState();
}

class _RememberPasswordState extends State<RememberPassword> {
  static bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          CustomCheckBox(
            onChecked: (value) {
              rememberMe = value;
              widget.onChecked(value);

              setState(() {});
            },
            isChecked: rememberMe,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              S.of(context).RememberMe,
              style: AppTextStyles.regular14.copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onTap,
            child: Text(
              S.of(context).ForgotPassword,
              style: AppTextStyles.regular14.copyWith(
                color: AppColors.primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';

import 'package:in_pocket/features/auth/presentation/views/widgets/custom_check_box.dart';
import 'package:in_pocket/generated/l10n.dart';

class RememberPassword extends StatefulWidget {
  const RememberPassword({super.key, required this.onChecked});
  final ValueChanged<bool> onChecked;
  @override
  State<RememberPassword> createState() => _RememberPasswordState();
}

class _RememberPasswordState extends State<RememberPassword> {
  bool isTermsAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckBox(
          onChecked: (value) {
            isTermsAccepted = value;
            widget.onChecked(value);
            setState(() {});
          },
          isChecked: isTermsAccepted,
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
        )
      ],
    );
  }
}

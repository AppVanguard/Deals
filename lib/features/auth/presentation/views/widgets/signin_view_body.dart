import 'package:flutter/material.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/core/widgets/custom_password_filed.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/auth_divider.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/remember_password.dart';
import 'package:in_pocket/generated/l10n.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  late String email, password;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          spacing: 20,
          children: [
            SizedBox(height: 76),
            Text(
              appTittle,
              style: AppTextStyles.bold46.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(),
            CustomTextFormField(
              hintText: S.of(context).EmailOrPhone,
              textInputType: TextInputType.text,
              label: S.of(context).Email,
            ),
            CustomPasswordField(),
            RememberPassword(
              onTap: () {},
              onChecked: (value) {
                rememberMe = value;
              },
            ),
            CustomButton(
              width: double.infinity,
              onPressed: () {},
              text: S.of(context).Login,
            ),
            AuthDivider(
              text: S.of(context).LoginWith,
            ),
          ],
        ),
      ),
    );
  }
}

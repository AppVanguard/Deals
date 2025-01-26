import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/core/widgets/custom_password_filed.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/custom_phone_field.dart';
import 'package:in_pocket/generated/l10n.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  late String email, password, fullName, confirmPassword;
  late PhoneNumber phone;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          spacing: 20,
          children: [
            SizedBox(),
            Center(
              child: Text(
                S.of(context).CreateNewAccount,
                style: AppTextStyles.bold18,
              ),
            ),
            SizedBox(),
            CustomTextFormField(
                hintText: S.of(context).FullName,
                textInputType: TextInputType.text,
                label: S.of(context).FullName),
            CustomTextFormField(
                hintText: S.of(context).Email,
                textInputType: TextInputType.emailAddress,
                label: S.of(context).Email),
            CustomPhoneField(
              label: S.of(context).Phone,
            ),
            CustomPasswordField(
              label: S.of(context).Password,
            ),
            CustomPasswordField(label: S.of(context).ConfirmPassword),
          ],
        ),
      ),
    );
  }
}

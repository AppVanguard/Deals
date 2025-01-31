import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/core/widgets/custom_password_filed.dart';
import 'package:in_pocket/features/auth/presentation/views/signin_view.dart';
import 'package:in_pocket/generated/l10n.dart';

class ResetPasswordViewBody extends StatefulWidget {
  const ResetPasswordViewBody({super.key});

  @override
  State<ResetPasswordViewBody> createState() => _ResetPasswordViewBodyState();
}

class _ResetPasswordViewBodyState extends State<ResetPasswordViewBody> {
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String password, confirmPassword;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          spacing: 20,
          children: [
            SvgPicture.asset(
              AppImages.assetsImagesResetPasswword,
            ),
            CustomPasswordField(
              label: S.of(context).Password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).PasswordValidator;
                }
                return null;
              },
              onSaved: (value) {
                password = value!;
              },
              onChanged: (value) {
                password = value;
              },
            ),
            CustomPasswordField(
              label: S.of(context).ConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).PasswordValidator;
                }
                if (value != password) {
                  return S.of(context).PasswordNotMatch;
                }
                return null;
              },
              onSaved: (value) {
                confirmPassword = value!;
              },
              onChanged: (value) {
                confirmPassword = value;
                final isValid = formKey.currentState!.validate();
                if (!isValid) {
                  setState(
                    () {
                      autovalidateMode = AutovalidateMode.always;
                    },
                  );
                }
              },
            ),
            CustomButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.popUntil(
                    context,
                    (route) => route.settings.name == SigninView.routeName,
                  );
                } else {
                  setState(() {
                    autovalidateMode = AutovalidateMode.always;
                  });
                }
              },
              text: S.of(context).ResetPassword,
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}

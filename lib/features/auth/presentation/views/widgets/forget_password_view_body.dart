import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';
import 'package:in_pocket/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:in_pocket/features/auth/presentation/views/signin_view.dart';
import 'package:in_pocket/generated/l10n.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  late String email;

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
            SizedBox(
              height: 10,
            ),
            Center(
              child: SvgPicture.asset(
                AppImages.assetsImagesForgetPassword,
              ),
            ),
            Text(
              S.of(context).ForgotPasswordTittle,
              style: AppTextStyles.bold32,
            ),
            Text(
              S.of(context).EnterYourEmail,
              style: AppTextStyles.regular14.copyWith(
                color: Color(0xFF717171),
              ),
            ),
            CustomTextFormField(
              hintText: S.of(context).Email,
              label: S.of(context).Email,
              textInputType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).EmailValidator;
                }
                return null;
              },
              onSaved: (value) {
                email = value!;
              },
            ),
            CustomButton(
              width: double.infinity,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pushNamed(
                    context,
                    OtpVerficationView.routeName,
                    arguments: [
                      email,
                      AppImages.assetsImagesOTB,
                      SigninView.routeName
                    ],
                  );
                }
              },
              text: S.of(context).SendCode,
            )
          ],
        ),
      ),
    );
  }
}

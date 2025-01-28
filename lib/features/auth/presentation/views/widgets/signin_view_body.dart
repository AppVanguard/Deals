import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/core/widgets/custom_password_filed.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';
import 'package:in_pocket/core/widgets/have_or_not_account.dart';
import 'package:in_pocket/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/signup_view.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/auth_divider.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/remember_password.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/third_party_auth.dart';
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).EPValidator;
                }
                return null;
              },
              hintText: S.of(context).EmailOrPhone,
              textInputType: TextInputType.text,
              label: S.of(context).Email,
            ),
            CustomPasswordField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).PasswordValidator;
                }
                return null;
              },
              label: S.of(context).Password,
            ),
            RememberPassword(
              onTap: () {},
              onChecked: (value) {
                rememberMe = value;
              },
            ),
            CustomButton(
              width: double.infinity,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  context.read<SigninCubit>().signInWithEmailAndPassword(rememberMe: rememberMe,
                        email: email,
                        password: password,
                      );
                }
              },
              text: S.of(context).Login,
            ),
            AuthDivider(
              text: S.of(context).LoginWith,
            ),
            ThirdPartyAuth(
              googleOnTap: () {
                context.read<SigninCubit>().signInWithGoogle(rememberMe: rememberMe);
              },
              facebookOnTap: () {
                context.read<SigninCubit>().signInWithFacebook(rememberMe: rememberMe);
              },
            ),
            HaveOrNotAccount(
              onTap: () {
                Navigator.pushNamed(context, SignupView.routeName);
              },
              question: S.of(context).DontHaveAccount,
              action: S.of(context).createAccount,
            )
          ],
        ),
      ),
    );
  }
}

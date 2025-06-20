import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/error_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/widgets/custom_password_filed.dart';
import 'package:deals/core/widgets/custom_text_form_field.dart';
import 'package:deals/core/widgets/have_or_not_account.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signin_cubit/signin_cubit.dart';
import 'package:deals/features/auth/presentation/views/forget_password/forget_password_view.dart';
import 'package:deals/features/auth/presentation/views/signup/signup_view.dart';
import 'package:deals/features/auth/presentation/views/widgets/auth_divider.dart';
import 'package:deals/features/auth/presentation/views/signin/widgets/remember_password.dart';
import 'package:deals/features/auth/presentation/views/widgets/third_party_auth.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({
    super.key,
    required this.serverError,
    required this.onTyping,
  });

  final String? serverError;
  final VoidCallback onTyping;

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.serverError != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 76),
            Center(child: SvgPicture.asset(AppImages.assetsImagesAppLogo)),
            const SizedBox(height: 32),
            if (hasError) ErrorBanner(message: widget.serverError!),
            CustomTextFormField(
              textInputType: TextInputType.text,
              onSaved: (v) => email = v!,
              onChanged: (_) => widget.onTyping(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? S.of(context).EPValidator : null,
              hintText: S.of(context).EmailOrPhone,
              label: S.of(context).Email,
              borderColor: hasError ? Colors.red : null,
            ),
            const SizedBox(height: 20),
            CustomPasswordField(
              onSaved: (v) => password = v!,
              onChanged: (_) => widget.onTyping(),
              validator: (v) => (v == null || v.isEmpty)
                  ? S.of(context).PasswordValidator
                  : null,
              label: S.of(context).Password,
              borderColor: hasError ? Colors.red : null,
            ),
            const SizedBox(height: 12),
            RememberPassword(
              onChecked: (v) => rememberMe = v,
              onTap: () => context.pushNamed(ForgetPasswordView.routeName),
            ),
            const SizedBox(height: 24),
            CustomButton(
              width: double.infinity,
              text: S.of(context).Login,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  context.read<SigninCubit>().signInWithEmailAndPassword(
                        email: email,
                        password: password,
                        rememberMe: rememberMe,
                      );
                }
              },
            ),
            const SizedBox(height: 32),
            AuthDivider(text: S.of(context).LoginWith),
            const SizedBox(height: 24),
            Center(
              child: ThirdPartyAuth(
                googleOnTap: () => context
                    .read<SigninCubit>()
                    .signInWithGoogle(rememberMe: rememberMe),
                facebookOnTap: () => context
                    .read<SigninCubit>()
                    .signInWithFacebook(rememberMe: rememberMe),
                appleOnTap: () => context
                    .read<SigninCubit>()
                    .signInWithApple(rememberMe: rememberMe),
              ),
            ),
            const SizedBox(height: 24),
            HaveOrNotAccount(
              question: S.of(context).DontHaveAccount,
              action: S.of(context).createAccount,
              onTap: () => context.pushNamed(SignupView.routeName),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

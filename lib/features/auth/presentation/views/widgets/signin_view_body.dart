import 'package:deals/core/widgets/error_banner.dart';
import 'package:deals/core/widgets/v_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/widgets/custom_password_filed.dart';
import 'package:deals/core/widgets/custom_text_form_field.dart';
import 'package:deals/core/widgets/have_or_not_account.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signin_cubit/signin_cubit.dart';
import 'package:deals/features/auth/presentation/views/forget_password_view.dart';
import 'package:deals/features/auth/presentation/views/signup_view.dart';
import 'package:deals/features/auth/presentation/views/widgets/auth_divider.dart';
import 'package:deals/features/auth/presentation/views/widgets/remember_password.dart';
import 'package:deals/features/auth/presentation/views/widgets/third_party_auth.dart';
import 'package:deals/generated/l10n.dart';

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
            const VGap(76),
            Center(
              child: Text(appTittle,
                  style:
                      AppTextStyles.bold46.copyWith(color: AppColors.primary)),
            ),
            const VGap(32),
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
            const VGap(20),
            CustomPasswordField(
              onSaved: (v) => password = v!,
              onChanged: (_) => widget.onTyping(),
              validator: (v) => (v == null || v.isEmpty)
                  ? S.of(context).PasswordValidator
                  : null,
              label: S.of(context).Password,
              borderColor: hasError ? Colors.red : null,
            ),
            const VGap(12),
            RememberPassword(
              onChecked: (v) => rememberMe = v,
              onTap: () => context.pushNamed(ForgetPasswordView.routeName),
            ),
            const VGap(24),
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
            const VGap(32),
            AuthDivider(text: S.of(context).LoginWith),
            const VGap(24),
            Center(
              child: ThirdPartyAuth(
                googleOnTap: () => context
                    .read<SigninCubit>()
                    .signInWithGoogle(rememberMe: rememberMe),
                facebookOnTap: () => context
                    .read<SigninCubit>()
                    .signInWithFacebook(rememberMe: rememberMe),
              ),
            ),
            const VGap(24),
            HaveOrNotAccount(
              question: S.of(context).DontHaveAccount,
              action: S.of(context).createAccount,
              onTap: () => context.pushNamed(SignupView.routeName),
            ),
            const VGap(32),
          ],
        ),
      ),
    );
  }
}

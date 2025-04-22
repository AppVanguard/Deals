import 'package:deals/core/widgets/v_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/widgets/custom_password_filed.dart';
import 'package:deals/core/widgets/custom_text_form_field.dart';
import 'package:deals/core/widgets/have_or_not_account.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signup_cubit/signup_cubit.dart';
import 'package:deals/features/auth/presentation/views/widgets/auth_divider.dart';
import 'package:deals/features/auth/presentation/views/widgets/custom_phone_field.dart';
import 'package:deals/features/auth/presentation/views/widgets/third_party_auth.dart';
import 'package:deals/generated/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  late String email, fullName, confirmPassword;
  String? password;
  PhoneNumber? phone;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VGap(32),
            Center(
              child: Text(S.of(context).CreateNewAccount,
                  style: AppTextStyles.bold18),
            ),
            const VGap(32),
            CustomTextFormField(
              validator: (v) =>
                  (v == null || v.isEmpty) ? S.of(context).FNValidator : null,
              onSaved: (v) => fullName = v!,
              hintText: S.of(context).FullName,
              textInputType: TextInputType.text,
              label: S.of(context).FullName,
            ),
            const VGap(20),
            CustomTextFormField(
              validator: (v) => (v == null || v.isEmpty)
                  ? S.of(context).EmailValidator
                  : null,
              onSaved: (v) => email = v!,
              hintText: S.of(context).Email,
              textInputType: TextInputType.emailAddress,
              label: S.of(context).Email,
            ),
            const VGap(20),
            CustomPhoneField(
              autovalidateMode: autovalidateMode,
              onSaved: (v) => phone = v!,
              label: S.of(context).Phone,
            ),
            const VGap(20),
            CustomPasswordField(
              validator: (v) => (v == null || v.isEmpty)
                  ? S.of(context).PasswordValidator
                  : null,
              onSaved: (v) => password = v!,
              onChanged: (v) => password = v,
              label: S.of(context).Password,
            ),
            const VGap(20),
            CustomPasswordField(
              validator: (v) {
                if (v == null || v.isEmpty) return S.of(context).FieldRequired;
                if (v != password) return S.of(context).PasswordNotMatch;
                return null;
              },
              label: S.of(context).ConfirmPassword,
              onSaved: (v) => confirmPassword = v!,
              onChanged: (v) => confirmPassword = v,
            ),
            const VGap(24),
            CustomButton(
              width: double.infinity,
              text: S.of(context).Register,
              onPressed: () {
                if (phone != null && phone!.isValidNumber()) {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    context.read<SignupCubit>().createUserWithEmailAndPassword(
                        email, password!, fullName, phone!.completeNumber);
                  } else {
                    setState(() => autovalidateMode = AutovalidateMode.always);
                  }
                } else {
                  customErrorTopSnackBar(
                      context: context, message: S.of(context).PhoneValidator);
                }
              },
            ),
            const VGap(24),
            AuthDivider(text: S.of(context).OrRegisterWith),
            const VGap(24),
            Center(
              child: ThirdPartyAuth(
                googleOnTap: () => context
                    .read<SignupCubit>()
                    .signInWithGoogle(rememberMe: false),
                facebookOnTap: () => context
                    .read<SignupCubit>()
                    .signInWithFacebook(rememberMe: false),
              ),
            ),
            const VGap(24),
            HaveOrNotAccount(
              question: S.of(context).AlreadyHaveAccount,
              action: S.of(context).Login,
              onTap: () => context.pop(),
            ),
            const VGap(32),
          ],
        ),
      ),
    );
  }
}

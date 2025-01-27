import 'package:flutter/material.dart';
import 'package:in_pocket/core/helper_functions/custom_top_snack_bar.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/core/widgets/custom_password_filed.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';
import 'package:in_pocket/core/widgets/have_or_not_account.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/auth_divider.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/custom_phone_field.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/third_party_auth.dart';
import 'package:in_pocket/generated/l10n.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  late String email, fullName, confirmPassword;
  String? password;
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).FNValidator;
                  }
                  return null;
                },
                onSaved: (value) {
                  fullName = value!;
                },
                hintText: S.of(context).FullName,
                textInputType: TextInputType.text,
                label: S.of(context).FullName),
            CustomTextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).EmailValidator;
                  }
                  return null;
                },
                hintText: S.of(context).Email,
                textInputType: TextInputType.emailAddress,
                label: S.of(context).Email),
            CustomPhoneField(
              autovalidateMode: autovalidateMode,
              onSaved: (value) {
                phone = value!;
              },
              onChanged: (value) {
                phone = value;
              },
              label: S.of(context).Phone,
            ),
            CustomPasswordField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).PasswordValidator;
                }
                return null;
              },
              onChanged: (value) {
                password = value;
              },
              onSaved: (value) {
                password = value!;
              },
              label: S.of(context).Password,
            ),
            CustomPasswordField(
              // Validate confirm password
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).FieldRequired;
                }
                if (value != password) {
                  return S.of(context).PasswordNotMatch;
                }
                return null;
              },
              label: S.of(context).ConfirmPassword,
              onSaved: (value) {
                confirmPassword = value!;
              },
              onChanged: (value) {
                // 1. Set the confirmPassword right away (optional,
                //    but helps if you want to re-check it immediately)
                confirmPassword = value;

                // 2. Trigger validation on the entire form
                final isValid = formKey.currentState!.validate();

                if (isValid) {
                  // 3. If valid, save all form fields
                  formKey.currentState!.save();

                  // Then proceed with your signup logic...
                  // e.g., call an API, navigate, etc.
                } else {
                  // If not valid, you can optionally set autovalidateMode
                  // so that errors appear immediately next time
                  setState(() {
                    autovalidateMode = AutovalidateMode.always;
                  });
                }
              },
            ),
            CustomButton(
              onPressed: () {
                if (phone.isValidNumber()) {
                  final isValid = formKey.currentState!.validate();

                  if (isValid) {
                    // 3. If valid, save all form fields
                    formKey.currentState!.save();

                    // Then proceed with your signup logic...
                    // e.g., call an API, navigate, etc.
                  } else {
                    // If not valid, you can optionally set autovalidateMode
                    // so that errors appear immediately next time
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                } else {
                  customErrorTopSnackBar(
                      context: context, message: S.of(context).PhoneValidator);
                }
              },
              text: S.of(context).Register,
              width: double.infinity,
            ),
            AuthDivider(text: S.of(context).OrRegisterWith),
            ThirdPartyAuth(),
            HaveOrNotAccount(
              onTap: () {
                Navigator.pop(context);
              },
              question: S.of(context).AlreadyHaveAccount,
              action: S.of(context).Login,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/widgets/custom_password_filed.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';

class ResetPasswordViewBody extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordViewBody(
      {super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordViewBody> createState() => _ResetPasswordViewBodyState();
}

class _ResetPasswordViewBodyState extends State<ResetPasswordViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String password, confirmPassword;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == SigninView.routeName,
          );
        } else if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is ResetPasswordLoading;
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              children: [
                SvgPicture.asset(AppImages.assetsImagesResetPasswword),
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
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                ),
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      log("The args sent now email: ${widget.email}, password: $password, otp: ${widget.otp}");
                      formKey.currentState!.save();
                      context.read<ResetPasswordCubit>().resetPassword(
                            email: widget.email,
                            otp: widget.otp,
                            newPassword: password,
                          );
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  text: S.of(context).ResetPassword,
                  width: double.infinity,
                ),
                if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}

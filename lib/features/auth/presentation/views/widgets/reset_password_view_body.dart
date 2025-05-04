// lib/features/auth/presentation/views/widgets/reset_password_view_body.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/widgets/custom_password_filed.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordViewBody extends StatefulWidget {
  final String email;
  final String otp;
  final String finalRoute; // NEW

  const ResetPasswordViewBody({
    super.key,
    required this.email,
    required this.otp,
    required this.finalRoute,
  });

  @override
  State<ResetPasswordViewBody> createState() => _ResetPasswordViewBodyState();
}

class _ResetPasswordViewBodyState extends State<ResetPasswordViewBody> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _pw = '', _confirm = '';
  AutovalidateMode _mode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          if (!context.mounted) return;
          context.goNamed(widget.finalRoute);
        } else if (state is ResetPasswordFailure) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final loading = state is ResetPasswordLoading;

        return SingleChildScrollView(
          child: Form(
            key: _form,
            autovalidateMode: _mode,
            child: Column(
              children: [
                SvgPicture.asset(AppImages.assetsImagesResetPasswword),
                CustomPasswordField(
                  label: S.of(context).Password,
                  validator: (v) => (v == null || v.isEmpty)
                      ? S.of(context).PasswordValidator
                      : null,
                  onSaved: (v) => _pw = v!,
                  onChanged: (v) => _pw = v,
                ),
                CustomPasswordField(
                  label: S.of(context).ConfirmPassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return S.of(context).PasswordValidator;
                    }
                    if (v != _pw) return S.of(context).PasswordNotMatch;
                    return null;
                  },
                  onSaved: (v) => _confirm = v!,
                  onChanged: (v) {
                    _confirm = v;
                    setState(() => _mode = AutovalidateMode.always);
                  },
                ),
                CustomButton(
                  width: double.infinity,
                  text: S.of(context).ResetPassword,
                  isLoading: loading,
                  onPressed: loading
                      ? () {}
                      : () {
                          if (_form.currentState!.validate()) {
                            _form.currentState!.save();
                            log("Resetting pw for ${widget.email}");
                            context.read<ResetPasswordCubit>().resetPassword(
                                  email: widget.email,
                                  otp: widget.otp,
                                  newPassword: _pw,
                                );
                          } else {
                            setState(() => _mode = AutovalidateMode.always);
                          }
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

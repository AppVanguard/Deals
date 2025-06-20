import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/widgets/custom_text_form_field.dart';
import 'package:deals/constants.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/auth/presentation/views/forget_password/forget_password_view.dart';

/// Pure-UI form; report (oldPw,newPw) through [onSubmit].
class ChangePasswordViewBody extends StatefulWidget {
  const ChangePasswordViewBody({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final Future<void> Function(String oldPw, String newPw) onSubmit;

  @override
  State<ChangePasswordViewBody> createState() => _ChangePasswordViewBodyState();
}

class _ChangePasswordViewBodyState extends State<ChangePasswordViewBody> {
  /// field values
  String _oldPw = '', _newPw = '', _confirmPw = '';

  /// visibility toggles
  bool _obOld = true, _obNew = true, _obConfirm = true;

  /// validation messages
  List<String> _newErrors = [];
  String? _confirmError;

  // ───────────────────────── validators ─────────────────────────
  void _validateNew(String v) {
    final s = S.of(context);
    final errs = <String>[];
    if (!RegExp(r'\d').hasMatch(v)) errs.add(s.passwordMustContainNumber);
    if (v.length < 6) errs.add(s.passwordMustBe6Characters);
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v)) {
      errs.add(s.passwordMustContainSpecial);
    }
    setState(() => _newErrors = errs);
  }

  void _validateConfirm(String v) {
    final s = S.of(context);
    setState(() {
      _confirmError = (v == _newPw) ? null : s.passwordNotMatching;
    });
  }

  bool get _canSubmit =>
      _oldPw.isNotEmpty &&
      _newPw.isNotEmpty &&
      _newErrors.isEmpty &&
      _confirmError == null &&
      !widget.isLoading;

  // ───────────────────────── UI ─────────────────────────
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Old-password row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.oldPassword, style: AppTextStyles.bold14),
              TextButton(
                onPressed: () {
                  context.pushNamed(ForgetPasswordView.routeName);
                },
                child: Text(
                  s.forgetThePassword,
                  style:
                      AppTextStyles.bold14.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          CustomTextFormField(
            hintText: s.oldPassword,
            label: '',
            textInputType: TextInputType.visiblePassword,
            obscureText: _obOld,
            validator: (_) => null,
            suffixIcon: IconButton(
              icon: Icon(_obOld ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obOld = !_obOld),
            ),
            onChanged: (v) => _oldPw = v,
            hasBorder: true,
          ),

          const SizedBox(height: 16),

          // New password
          Text(s.newPassword, style: AppTextStyles.bold14),
          const SizedBox(height: 4),
          CustomTextFormField(
            hintText: s.newPassword,
            label: '',
            textInputType: TextInputType.visiblePassword,
            obscureText: _obNew,
            validator: (_) => null,
            suffixIcon: IconButton(
              icon: Icon(_obNew ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obNew = !_obNew),
            ),
            onChanged: (v) {
              _newPw = v;
              _validateNew(v);
              _validateConfirm(_confirmPw);
            },
            hasBorder: true,
          ),
          if (_newErrors.isNotEmpty)
            ..._newErrors.map(
              (e) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(e,
                    style: AppTextStyles.regular12
                        .copyWith(color: AppColors.primary)),
              ),
            ),

          const SizedBox(height: 16),

          // Confirm password
          Text(s.confirmNewPassword, style: AppTextStyles.bold14),
          const SizedBox(height: 4),
          CustomTextFormField(
            hintText: s.confirmNewPassword,
            label: '',
            textInputType: TextInputType.visiblePassword,
            obscureText: _obConfirm,
            validator: (_) => null,
            suffixIcon: IconButton(
              icon: Icon(_obConfirm ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obConfirm = !_obConfirm),
            ),
            onChanged: (v) {
              _confirmPw = v;
              _validateConfirm(v);
            },
            hasBorder: true,
          ),
          if (_confirmError != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(_confirmError!,
                  style: AppTextStyles.regular12
                      .copyWith(color: AppColors.primary)),
            ),

          const SizedBox(height: 24),

          // Submit button
          CustomButton(
            width: double.infinity,
            text: s.changePassword,
            isLoading: widget.isLoading,
            buttonColor: _canSubmit
                ? AppColors.primary
                : AppColors.primary.withOpacity(.4),
            textColor: Colors.white,
            onPressed: _canSubmit
                ? () => widget.onSubmit(_oldPw.trim(), _newPw.trim())
                : () {},
          ),
        ],
      ),
    );
  }
}

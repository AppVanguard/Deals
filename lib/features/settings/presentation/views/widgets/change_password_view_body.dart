import 'package:deals/constants.dart';
import 'package:deals/features/auth/presentation/views/forget_password_view.dart';
import 'package:deals/features/settings/presentation/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:go_router/go_router.dart';

/// A pure‐UI form for changing password, using CustomButton.
/// - [isLoading]: shows spinner in the button and disables it
/// - [onSubmit]: called with (oldPassword, newPassword)
class ChangePasswordViewBody extends StatefulWidget {
  final bool isLoading;
  final Future<void> Function(String oldPassword, String newPassword) onSubmit;

  const ChangePasswordViewBody({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<ChangePasswordViewBody> createState() => _ChangePasswordViewBodyState();
}

class _ChangePasswordViewBodyState extends State<ChangePasswordViewBody> {
  late final TextEditingController _oldController;
  late final TextEditingController _newController;
  late final TextEditingController _confirmController;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  List<String> _newPasswordErrors = [];
  String? _confirmError;

  @override
  void initState() {
    super.initState();
    _oldController = TextEditingController();
    _newController = TextEditingController()..addListener(_validateNew);
    _confirmController = TextEditingController()..addListener(_validateConfirm);
  }

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _validateNew() {
    final v = _newController.text;
    final errs = <String>[];
    final s = S.of(context);

    if (!RegExp(r'\d').hasMatch(v)) {
      errs.add(s.passwordMustContainNumber);
    }
    if (v.length < 6) {
      errs.add(s.passwordMustBe6Characters);
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v)) {
      errs.add(s.passwordMustContainSpecial);
    }
    setState(() => _newPasswordErrors = errs);
  }

  void _validateConfirm() {
    final v = _confirmController.text;
    final s = S.of(context);

    setState(() {
      _confirmError = (v.isEmpty || v == _newController.text)
          ? null
          : s.passwordNotMatching;
    });
  }

  bool get _canSubmit =>
      _oldController.text.isNotEmpty &&
      _newController.text.isNotEmpty &&
      _newPasswordErrors.isEmpty &&
      _confirmController.text == _newController.text &&
      !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Old Password + Forget link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.oldPassword, style: AppTextStyles.bold14),
              TextButton(
                onPressed: () {
                  context.pushNamed(
                    ForgetPasswordView.routeName,
                    extra: {kNextAfterReset: SettingsView.routeName},
                  );
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
          TextField(
            controller: _oldController,
            obscureText: _obscureOld,
            decoration: InputDecoration(
              hintText: s.oldPassword,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureOld ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _obscureOld = !_obscureOld),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // New Password
          Text(s.newPassword, style: AppTextStyles.bold14),
          const SizedBox(height: 4),
          TextField(
            controller: _newController,
            obscureText: _obscureNew,
            decoration: InputDecoration(
              hintText: s.newPassword,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
          ),
          if (_newPasswordErrors.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final err in _newPasswordErrors)
              Text(
                err,
                style:
                    AppTextStyles.regular12.copyWith(color: AppColors.primary),
              ),
          ],

          const SizedBox(height: 16),

          // Confirm New Password
          Text(s.confirmNewPassword, style: AppTextStyles.bold14),
          const SizedBox(height: 4),
          TextField(
            controller: _confirmController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              hintText: s.confirmNewPassword,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
          ),
          if (_confirmError != null) ...[
            const SizedBox(height: 8),
            Text(
              _confirmError!,
              style: AppTextStyles.regular12.copyWith(color: AppColors.primary),
            ),
          ],

          const SizedBox(height: 24),

          // CustomButton instead of ElevatedButton
          CustomButton(
            width: double.infinity,
            onPressed: _canSubmit
                ? () => widget.onSubmit(
                    _oldController.text.trim(), _newController.text.trim())
                : () {},
            text: s.changePassword,
            buttonColor: _canSubmit
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.5),
            textColor: Colors.white,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}

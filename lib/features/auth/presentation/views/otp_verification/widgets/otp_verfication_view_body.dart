import 'package:deals/core/utils/dev_log.dart';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_resend_timer_cubit/otp_resend_timer_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_resend_timer_cubit/otp_resend_timer_state.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deals/generated/l10n.dart';
import 'otp_digit_field.dart';

class OTPVerificationViewBody extends StatefulWidget {
  const OTPVerificationViewBody({
    super.key,
    required this.email,
    required this.id,
    this.image,
    required this.routeName,
    this.errorMessage,
    required this.isRegister,
  });

  final String email;
  final String id;
  final String? image;
  final String routeName;
  final String? errorMessage;
  final bool isRegister;

  @override
  State<OTPVerificationViewBody> createState() =>
      _OTPVerificationViewBodyState();
}

class _OTPVerificationViewBodyState extends State<OTPVerificationViewBody> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<bool> _hasValue = List.generate(4, (_) => false);
  final List<bool> _isError = List.generate(4, (_) => false);
  bool _showFieldError = false;

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {
      _hasValue[index] = value.isNotEmpty;
      _isError[index] = false;
    });
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (index == 3) {
      _focusNodes[index].unfocus();
    }
  }

  void _onKey(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty) {
      if (index > 0) {
        setState(() {
          _hasValue[index - 1] = false;
          _controllers[index - 1].clear();
          _isError[index - 1] = false;
        });
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  void _validateFields() {
    bool hasEmptyFields = false;
    setState(() {
      for (int i = 0; i < 4; i++) {
        if (_controllers[i].text.isEmpty) {
          _isError[i] = true;
          hasEmptyFields = true;
        }
      }
      _showFieldError = hasEmptyFields;
    });

    if (!hasEmptyFields) {
      final otpCode = _controllers.map((e) => e.text).join();
      log('Entered OTP: $otpCode');

      final cubit = context.read<OtpVerifyCubit>();
      if (widget.isRegister) {
        cubit.verifyOtpForRegister(email: widget.email, otp: otpCode);
      } else {
        cubit.verifyOtpForReset(email: widget.email, otp: otpCode);
      }
    }
  }

  void _resendOtp() {
    context.read<OtpVerifyCubit>().resendOtp(widget.email);
    context.read<OtpResendTimerCubit>().startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<OtpResendTimerCubit>().state;
    final bool timerRunning = timerState is TimerRunning;
    final int secondsLeft = timerRunning ? (timerState).timeLeft : 0;
    final bool isVerifying =
        context.watch<OtpVerifyCubit>().state is OtpVerifyLoading;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Illustration
            if (widget.image != null) SvgPicture.asset(widget.image!),

            // Title
            Text(
              widget.image != null
                  ? S.of(context).OTPVerification
                  : S.of(context).EnterCode,
              style: AppTextStyles.bold32,
            ),

            // Sub-title
            Text(
              '${S.of(context).OTPSent}\n${widget.email}',
              style: AppTextStyles.regular14
                  .copyWith(color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // OTP fields
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return OtpDigitField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    isError: _isError[index],
                    hasValue: _hasValue[index],
                    showGlobalError: widget.errorMessage != null,
                    onKey: (event) => _onKey(event, index),
                    onChanged: (v) => _onChanged(v, index),
                  );
                }),
              ),
            ),

            if (_showFieldError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  S.of(context).OTPValidator,
                  style:
                      AppTextStyles.regular14.copyWith(color: Colors.redAccent),
                ),
              ),

            if (widget.errorMessage != null)
              Container(
                width: 122,
                height: 36,
                margin: const EdgeInsets.only(top: 8),
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFEBEB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppImages.assetsImagesWarning),
                    const SizedBox(width: 8),
                    Text(
                      widget.errorMessage!,
                      style: AppTextStyles.regular13
                          .copyWith(color: AppColors.accent),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // VERIFY button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: CustomButton(
                width: double.infinity,
                text: S.of(context).Verify,
                onPressed: isVerifying ? () {} : _validateFields,
                isLoading: isVerifying,
              ),
            ),

            const SizedBox(height: 12),

            // Resend link / timer
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: S.of(context).NoCode,
                    style: AppTextStyles.regular14
                        .copyWith(color: AppColors.secondaryText),
                  ),
                  const TextSpan(text: ' '),
                  timerRunning
                      ? TextSpan(
                          text: '${S.of(context).Resend} ${secondsLeft}s',
                          style: AppTextStyles.regular14
                              .copyWith(color: AppColors.primary),
                        )
                      : TextSpan(
                          text: S.of(context).Resend,
                          recognizer: TapGestureRecognizer()
                            ..onTap = _resendOtp,
                          style: AppTextStyles.bold14
                              .copyWith(color: AppColors.primary),
                        ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

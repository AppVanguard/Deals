import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/otp_resend_timer_cubit/otp_resend_timer_cubit.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/otp_resend_timer_cubit/otp_resend_timer_state.dart';
import 'package:in_pocket/generated/l10n.dart';

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
      // Here, for reset password flow, call verifyOtpForReset.
      widget.isRegister
          ? context
              .read<OtpVerifyCubit>()
              .verifyOtpForRegister(email: widget.email, otp: otpCode)
          : context
              .read<OtpVerifyCubit>()
              .verifyOtpForReset(email: widget.email, otp: otpCode);
    }
  }

  void _resendOtp() {
    context.read<OtpVerifyCubit>().resendOtp(widget.email);
    context.read<OtpResendTimerCubit>().startTimer();
  }

  OutlineInputBorder buildBorder(int index) {
    Color borderColor;
    if (widget.errorMessage != null) {
      borderColor = Colors.red;
    } else {
      borderColor = _isError[index]
          ? Colors.red
          : (_hasValue[index] ? AppColors.primary : Colors.grey.shade400);
    }
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  OutlineInputBorder buildFocusedBorder(int index) {
    final borderColor =
        widget.errorMessage != null ? Colors.red : AppColors.primary;
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: _isError[index] ? Colors.red : borderColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<OtpResendTimerCubit>().state;
    bool timerIsRunning = false;
    int secondsLeft = 0;
    if (timerState is TimerRunning) {
      timerIsRunning = true;
      secondsLeft = timerState.timeLeft;
    }
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (widget.image != null)
              SvgPicture.asset(widget.image!)
            else
              const SizedBox(),
            if (widget.image != null)
              Text(
                S.of(context).OTPVerification,
                style: AppTextStyles.bold32,
              )
            else
              Text(
                S.of(context).EnterCode,
                style: AppTextStyles.bold32,
              ),
            Text(
              "${S.of(context).OTPSent} \n ${widget.email}",
              style: AppTextStyles.regular14
                  .copyWith(color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Focus(
                      onKeyEvent: (node, event) {
                        _onKey(event, index);
                        return KeyEventResult.ignored;
                      },
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        maxLength: 1,
                        cursorHeight: 30,
                        style: AppTextStyles.semiBold32,
                        decoration: InputDecoration(
                          counterText: "",
                          enabledBorder: buildBorder(index),
                          focusedBorder: buildFocusedBorder(index),
                          border: buildBorder(index),
                        ),
                        onChanged: (value) => _onChanged(value, index),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (_showFieldError)
              Text(
                S.of(context).OTPValidator,
                style: AppTextStyles.regular14.copyWith(color: Colors.red),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: CustomButton(
                width: double.infinity,
                onPressed: _validateFields,
                text: S.of(context).Verify,
              ),
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: S.of(context).NoCode,
                    style: AppTextStyles.regular14
                        .copyWith(color: AppColors.secondaryText),
                  ),
                  const TextSpan(text: ' '),
                  if (timerIsRunning)
                    TextSpan(
                      text: '${S.of(context).Resend} ${secondsLeft}s',
                      style: AppTextStyles.regular14
                          .copyWith(color: AppColors.primary),
                    )
                  else
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = _resendOtp,
                      text: S.of(context).Resend,
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

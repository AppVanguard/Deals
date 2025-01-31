import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/generated/l10n.dart';

class OTPVerificationViewBody extends StatefulWidget {
  const OTPVerificationViewBody({super.key, required this.email});
  final String email;

  @override
  State<OTPVerificationViewBody> createState() =>
      _OTPVerificationViewBodyState();
}

class _OTPVerificationViewBodyState extends State<OTPVerificationViewBody> {
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<bool> _hasValue = List.generate(4, (index) => false);
  final List<bool> _isError = List.generate(4, (index) => false);

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _showErrorMessage = false;

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

    if (value.isNotEmpty) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
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
          _isError[index - 1] = false; // Reset validation on backspace
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
          _isError[i] = true; // Mark the field as an error
          hasEmptyFields = true;
        }
      }
      _showErrorMessage = hasEmptyFields;
    });

    if (!hasEmptyFields) {
      String otpCode = _controllers.map((e) => e.text).join();
      log("Entered OTP: $otpCode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppImages.assetsImagesOTB),
              Text(
                S.of(context).OTPVerification,
                style: AppTextStyles.bold32,
              ),
              Text(
                "${S.of(context).OTPSent} \n ${widget.email}",
                style: AppTextStyles.regular14
                    .copyWith(color: AppColors.secondaryText),
                textAlign: TextAlign.center,
              ),
              Row(
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
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : S.of(context).OTPValidator;
                        },
                        cursorHeight: 30,
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        maxLength: 1,
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
              if (_showErrorMessage)
                // Container(
                //   width: 122,
                //   height: 36,
                //   decoration: ShapeDecoration(
                //     color: Color(0xFFFFEBEB),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                //   child: Row(
                //     spacing: 8,
                //     // mainAxisSize: MainAxisSize.min,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       SvgPicture.asset(
                //         AppImages.assetsImagesWarning,
                //       ),
                //       Text(
                //         S.of(context).InvalidCode,
                //         style: AppTextStyles.regular13
                //             .copyWith(color: AppColors.accent),
                //       ),
                //     ],
                //   ),
                // ),
                Text(
                  S.of(context).OTPValidator,
                  style: AppTextStyles.regular14.copyWith(color: Colors.red),
                ),
              CustomButton(
                width: double.infinity,
                onPressed: _validateFields,
                text: S.of(context).Verify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Border when field is empty
  OutlineInputBorder buildBorder(int index) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: _isError[index]
            ? Colors.red // Field border turns red if empty
            : (_hasValue[index] ? AppColors.primary : Colors.grey.shade400),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Border when field is focused
  OutlineInputBorder buildFocusedBorder(int index) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: _isError[index]
            ? Colors.red // Keep red border even when focused if empty
            : AppColors.primary,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}

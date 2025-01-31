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
          _hasValue[index - 1] = false; // Reset border when cleared
          _controllers[index - 1].clear();
        });
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 1,),
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
                    child: TextField(textAlignVertical: TextAlignVertical.top,
                      cursorHeight: 30,
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: AppTextStyles.semiBold32,
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: buildBorder(index),
                        focusedBorder: buildFocusedBorder(),
                        border: buildBorder(index),
                      ),
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  ),
                );
              }),
            ),
            CustomButton(
              width: double.infinity,
              onPressed: () {
                String otpCode = _controllers.map((e) => e.text).join();
                log("Entered OTP: $otpCode");
              },
              text: S.of(context).Verify,
            )
          ],
        ),
      ),
    );
  }

  OutlineInputBorder buildFocusedBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primary,
        width: 2, // Better visibility
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }

  OutlineInputBorder buildBorder(int index) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: _hasValue[index]
            ? AppColors.primary // Field with value is colored
            : Colors.grey.shade400, // Default border
        width: 2, // Better visibility
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}

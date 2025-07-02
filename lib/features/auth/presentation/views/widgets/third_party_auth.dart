import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deals/core/utils/app_images.dart';

/// Row of social auth icon buttons for Google/Facebook.
class ThirdPartyAuth extends StatelessWidget {
  const ThirdPartyAuth({super.key, this.googleOnTap, this.facebookOnTap});

  /// Handler for Google sign-in.
  final VoidCallback? googleOnTap;
  /// Handler for Facebook sign-in.
  final VoidCallback? facebookOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: googleOnTap,
          child: SvgPicture.asset(
            AppImages.assetsImagesGoogleIcon,
            width: 40,
            height: 40,
          ),
        ),
      ],
    );
  }
}

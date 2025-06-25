import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deals/core/utils/app_images.dart';

/// Row of social auth icon buttons for Google/Facebook/Apple.

class ThirdPartyAuth extends StatelessWidget {
  /// Creates a row of clickable icons for third-party authentication.
  const ThirdPartyAuth({
    super.key,
    this.googleOnTap,
    this.facebookOnTap,
    this.appleOnTap,
  });

  /// Handler for Google sign-in.
  final void Function()? googleOnTap;

  /// Handler for Facebook sign-in.
  final void Function()? facebookOnTap;

  /// Handler for Apple sign-in.
  final void Function()? appleOnTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        GestureDetector(
          onTap: googleOnTap,
          child: SvgPicture.asset(
            AppImages.assetsImagesGoogleIcon,
            width: 40,
            height: 40,
          ),
        ),
        // GestureDetector(
        //   onTap: facebookOnTap,
        //   child: SvgPicture.asset(
        //     AppImages.assetsImagesFacebookIcon,
        //     width: 40,
        //     height: 40,
        //   ),
        // ),
        Platform.isIOS
            ? GestureDetector(
                onTap: appleOnTap,
                child: SvgPicture.asset(
                  AppImages.assetsImagesAppleIcon,
                  width: 40,
                  height: 40,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

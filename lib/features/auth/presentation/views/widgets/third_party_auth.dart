import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deals/core/utils/app_images.dart';

class ThirdPartyAuth extends StatelessWidget {
  const ThirdPartyAuth(
      {super.key, this.googleOnTap, this.facebookOnTap, this.appleOnTap});
  final void Function()? googleOnTap;
  final void Function()? facebookOnTap;
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
        GestureDetector(
          onTap: facebookOnTap,
          child: SvgPicture.asset(
            AppImages.assetsImagesFacebookIcon,
            width: 40,
            height: 40,
          ),
        ),
        GestureDetector(
          onTap: appleOnTap,
          child: SvgPicture.asset(
            AppImages.assetsImagesAppleIcon,
            width: 40,
            height: 40,
          ),
        ),
      ],
    );
  }
}

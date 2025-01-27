import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_images.dart';

class ThirdPartyAuth extends StatelessWidget {
  const ThirdPartyAuth({super.key, this.googleOnTap, this.facebookOnTap});
  final void Function()? googleOnTap;
  final void Function()? facebookOnTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
      ],
    );
  }
}

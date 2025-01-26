import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_images.dart';

class ThirdPartyAuth extends StatelessWidget {
  const ThirdPartyAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppImages.assetsImagesGoogleIcon,
          width: 40,
          height: 40,
        ),
        Image.asset(
          AppImages.assetsImagesFacebook,
          // width: 40,
          // height: 40,
        ),
      ],
    );
  }
}

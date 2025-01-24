import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_images.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    // required this.tittle,
    // required this.subTittle,
  });
  final String image;
  //  tittle, subTittle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(AppImages.assetsImagesMaskgroup),
      ],
    );
  }
}

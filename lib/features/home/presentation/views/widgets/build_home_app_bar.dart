import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';

AppBar buildHomeAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.primary,
            size: 32,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      },
    ),
    title: Row(
      spacing: 16,
      children: [
        Text(
          appTittle,
          style: AppTextStyles.bold24.copyWith(color: AppColors.primary),
        ),
        SvgPicture.asset(AppImages.assetsImagesRefer),
        SvgPicture.asset(AppImages.assetsImagesSearch),
        Icon(
          Icons.notifications_none_outlined,
          size: 32,
          color: AppColors.primary,
        )
      ],
    ),
  );
}

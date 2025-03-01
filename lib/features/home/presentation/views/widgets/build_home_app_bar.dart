import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/features/search/presentation/views/search_view.dart';

AppBar buildHomeAppBar(BuildContext context) {
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
        Spacer(),
        SvgPicture.asset(AppImages.assetsImagesRefer),
        GestureDetector(
          child: SvgPicture.asset(AppImages.assetsImagesSearch),
          onTap: () {
            Navigator.pushNamed(context, SearchView.routeName);
          },
        ),
        Icon(
          Icons.notifications_none_outlined,
          size: 32,
          color: AppColors.primary,
        )
      ],
    ),
  );
}

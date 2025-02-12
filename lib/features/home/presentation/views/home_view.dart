import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/custom_app_drawer.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.userData});
  static const String routeName = 'home';
  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(),
      appBar: AppBar(
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
      ),
      drawer: CustomAppDrawer(
        userData: userData,
      ), // Use your custom drawer here
      body: const HomeViewBody(),
    );
  }
}

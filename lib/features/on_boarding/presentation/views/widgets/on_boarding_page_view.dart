import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/features/on_boarding/presentation/views/widgets/page_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          image: AppImages.assetsImagesOnBoardingP1,
        ),
        // PageViewItem(
        //   image: AppImages.assetsImagesOnBoardingP2,
        // ),
        // PageViewItem(
        //   image: AppImages.assetsImagesOnBoardingP3,
        // ),
      ],
    );
  }
}

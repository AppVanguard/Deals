import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_images.dart';
import 'page_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.pageController,
    this.onPageChanged,
  });

  final PageController pageController;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: [
        PageViewItem(
          image: AppImages.assetsImagesOnBoardingP1,
          tittle: s.p1OnBoardingTittle,
          subTittleFirst: s.p1OnBoardingSubTittleFirstWord,
          subTittle: s.p1OnBoardingSubTittle,
        ),
        PageViewItem(
          image: AppImages.assetsImagesOnBoardingP2,
          tittle: s.p2OnBoardingTittle,
          subTittleFirst: s.p2OnBoardingSubTittleFirstWord,
          subTittle: s.p2OnBoardingSubTittle,
        ),
        PageViewItem(
          image: AppImages.assetsImagesOnBoardingP3,
          tittle: s.p3OnBoardingTittle,
          subTittleFirst: s.p3OnBoardingSubTittleFirstWord,
          subTittle: s.p3OnBoardingSubTittle,
        ),
      ],
    );
  }
}

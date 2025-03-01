import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/on_boarding/presentation/views/widgets/page_view_item.dart';
import 'package:deals/generated/l10n.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView(
      {super.key, required this.pageController, this.onPageChanged});
  final PageController pageController;
  final void Function(int)? onPageChanged;
  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: onPageChanged,
      controller: pageController,
      children: [
        PageViewItem(
          image: AppImages.assetsImagesOnBoardingP1,
          tittle: S.of(context).p1OnBoardingTittle,
          subTittleFirst: S.of(context).p1OnBoardingSubTittleFirstWord,
          subTittle: S.of(context).p1OnBoardingSubTittle,
        ),
        PageViewItem(
          image: AppImages.assetsImagesOnBoardingP2,
          tittle: S.of(context).p2OnBoardingTittle,
          subTittleFirst: S.of(context).p2OnBoardingSubTittleFirstWord,
          subTittle: S.of(context).p2OnBoardingSubTittle,
        ),
        PageViewItem(
          image: AppImages.assetsImagesOnBoardingP3,
          tittle: S.of(context).p3OnBoardingTittle,
          subTittleFirst: S.of(context).p3OnBoardingSubTittleFirstWord,
          subTittle: S.of(context).p3OnBoardingSubTittle,
        ),
      ],
    );
  }
}

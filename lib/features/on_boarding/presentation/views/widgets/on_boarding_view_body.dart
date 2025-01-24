import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/features/on_boarding/presentation/views/widgets/on_boarding_page_view.dart';
import 'package:in_pocket/features/splash/presentation/views/splash_view.dart';
import 'package:in_pocket/generated/l10n.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late PageController pageController;
  var currentPage = 0;
  @override
  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      currentPage = pageController.page!.round();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 34,
        ),
        Expanded(
          child: OnBoardingPageView(
            onPageChanged: (index) {
              currentPage = index;
              // log(currentPage.toString());
            },
            pageController: pageController,
          ),
        ),
        DotsIndicator(
          dotsCount: 3,
          position: currentPage,
          decorator: DotsDecorator(
            activeColor: AppColors.primary,
            color: AppColors.lightPrimary,
          ),
        ),
        currentPage == 0
            ? CustomButton(
                width: double.infinity,
                onPressed: () {
                  pageController.animateToPage(
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 300),
                    ++currentPage,
                  );
                },
                text: S.of(context).GetStarted)
            : Row(
                spacing: 10,
                children: [
                  SizedBox(width: 10),
                  TextButton(
                      onPressed: () {
                        pageController.animateToPage(
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 300),
                          --currentPage,
                        );
                      },
                      child: Text(
                        S.of(context).Previous,
                        style: AppTextStyles.bold14
                            .copyWith(color: AppColors.tertiaryText),
                      )),
                  Expanded(
                      child: CustomButton(
                          onPressed: () {
                            currentPage == 1
                                ? pageController.animateToPage(
                                    curve: Curves.easeIn,
                                    duration: Duration(milliseconds: 300),
                                    ++currentPage,
                                  )
                                : Navigator.pushReplacementNamed(
                                    context, SplashView.routeName);
                          },
                          text: S.of(context).Next)),
                ],
              ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: S.of(context).HaveAccount,
                style: AppTextStyles.regular14.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: S.of(context).Login,
                style: AppTextStyles.bold14.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

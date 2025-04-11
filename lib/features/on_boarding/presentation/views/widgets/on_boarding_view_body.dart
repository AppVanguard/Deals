// lib/features/on_boarding/presentation/views/widgets/on_boarding_view_body.dart

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:go_router/go_router.dart';

import 'package:deals/constants.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/widgets/have_or_not_account.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/on_boarding/presentation/views/widgets/on_boarding_page_view.dart';
import 'package:deals/generated/l10n.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 34),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OnBoardingPageView(
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    pageController: pageController,
                  ),
                ),
              ),
              DotsIndicator(
                dotsCount: 3,
                position: currentPage,
                decorator: const DotsDecorator(
                  activeColor: AppColors.primary,
                  color: AppColors.lightPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: currentPage == 0
                    ? CustomButton(
                        width: double.infinity,
                        onPressed: () {
                          pageController.animateToPage(
                            currentPage + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        text: S.of(context).GetStarted,
                      )
                    : Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              pageController.animateToPage(
                                currentPage - 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Text(
                              S.of(context).Previous,
                              style: AppTextStyles.bold14
                                  .copyWith(color: AppColors.tertiaryText),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: currentPage == 1
                                ? CustomButton(
                                    onPressed: () {
                                      pageController.animateToPage(
                                        currentPage + 1,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    text: S.of(context).Next,
                                  )
                                : currentPage == 2
                                    ? CustomButton(
                                        onPressed: () {
                                          Prefs.setBool(
                                              kIsOnBoardingViewSeen, true);
                                          // go_router replace
                                          context.goNamed(SigninView.routeName);
                                        },
                                        text: S.of(context).JoinNow,
                                      )
                                    : const SizedBox(),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 10),
              HaveOrNotAccount(
                question: S.of(context).HaveAccount,
                action: S.of(context).Login,
                onTap: () {
                  Prefs.setBool(kIsOnBoardingViewSeen, true);
                  // go_router replace
                  context.goNamed(SigninView.routeName);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

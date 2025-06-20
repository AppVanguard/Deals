import 'package:deals/constants.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/widgets/have_or_not_account.dart';
import 'package:deals/features/auth/presentation/views/signin/signin_view.dart';
import 'package:deals/features/on_boarding/presentation/views/widgets/on_boarding_page_view.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:go_router/go_router.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() => setState(() {
            _currentPage = _pageController.page!.round();
          }));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          return Column(
            children: [
              SizedBox(height: h * .04), // 4 % top padding
              // ─── Slides ───
              Expanded(
                flex: 7, // ~70 % of height
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OnBoardingPageView(
                    pageController: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                  ),
                ),
              ),
              // ─── Dots ───
              DotsIndicator(
                dotsCount: 3,
                position: _currentPage,
                decorator: const DotsDecorator(
                  activeColor: AppColors.primary,
                  color: AppColors.lightPrimary,
                ),
              ),
              SizedBox(height: h * .03),
              // ─── Bottom buttons ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildBottomButtons(context),
              ),
              SizedBox(height: h * .015),
              // ─── “Have an account?” link ───
              HaveOrNotAccount(
                question: S.of(context).HaveAccount,
                action: S.of(context).Login,
                onTap: () {
                  Prefs.setBool(kIsOnBoardingViewSeen, true);
                  context.goNamed(SigninView.routeName);
                },
              ),
              SizedBox(height: h * .03),
            ],
          );
        },
      ),
    );
  }

  // ───────────────────────── helpers ─────────────────────────
  Widget _buildBottomButtons(BuildContext context) {
    final s = S.of(context);

    if (_currentPage == 0) {
      return CustomButton(
        width: double.infinity,
        text: s.GetStarted,
        onPressed: () => _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        ),
      );
    }

    if (_currentPage == 1) {
      return Row(
        children: [
          _prevButton(context),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: s.Next,
              onPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              ),
            ),
          ),
        ],
      );
    }

    // _currentPage == 2
    return Row(
      children: [
        _prevButton(context),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(
            text: s.JoinNow,
            onPressed: () {
              Prefs.setBool(kIsOnBoardingViewSeen, true);
              context.goNamed(SigninView.routeName);
            },
          ),
        ),
      ],
    );
  }

  Widget _prevButton(BuildContext context) => TextButton(
        onPressed: () => _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        ),
        child: Text(
          S.of(context).Previous,
          style: AppTextStyles.bold14.copyWith(color: AppColors.tertiaryText),
        ),
      );
}

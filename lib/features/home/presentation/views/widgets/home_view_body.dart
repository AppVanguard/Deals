import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/sales_carousel.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/top_cash_backs.dart';
import 'package:in_pocket/generated/l10n.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the grid
    List<Map<String, String>> cashbackItems = [
      {"name": "H&M", "image": AppImages.assetsImagesOnBoardingP1},
      {"name": "AWS", "image": AppImages.assetsImagesOnBoardingP2},
      {"name": "SHEIN", "image": AppImages.assetsImagesOnBoardingP3},
      {"name": "Kroger", "image": AppImages.assetsImagesTest1},
      {"name": "H&M", "image": AppImages.assetsImagesOnBoardingP1},
      {"name": "AWS", "image": AppImages.assetsImagesTest2},
      {"name": "SHEIN", "image": AppImages.assetsImagesTest3},
      {"name": "Kroger", "image": AppImages.assetsImagesTest1},
      // Add more items as needed
    ];

    return CustomScrollView(
      slivers: [
        // Header Text
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              S
                  .of(context)
                  .Save_money_with_us, // Assuming this is your localized string
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Image Carousel (using the extracted widget)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SalesCarousel(),
          ),
        ),
        // Top Cashbacks section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).Top_cashbacks, style: AppTextStyles.bold18),
                Text(
                  S.of(context).See_All,
                  style: AppTextStyles.regular14
                      .copyWith(color: AppColors.primary),
                )
              ],
            ),
          ),
        ),
        // Cashback Grid (Two rows scrolling horizontally)
        TopCashBacks(cashbackItems: cashbackItems),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).Top_coupons, style: AppTextStyles.bold18),
                Text(
                  S.of(context).See_All,
                  style: AppTextStyles.regular14
                      .copyWith(color: AppColors.primary),
                )
              ],
            ),
          ),
        ),
        TopCashBacks(cashbackItems: cashbackItems),
      ],
    );
  }
}

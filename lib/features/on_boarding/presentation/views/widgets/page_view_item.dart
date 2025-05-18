import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    required this.tittle,
    required this.subTittleFirst,
    required this.subTittle,
  });

  final String image, tittle, subTittleFirst, subTittle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image takes ~55 % of available slide height
            SizedBox(
              height: h * .55,
              child: Image.asset(image, fit: BoxFit.contain),
            ),
            SizedBox(height: h * .05),
            Text(
              tittle,
              style: AppTextStyles.bold22,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: h * .02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: subTittleFirst,
                      style: AppTextStyles.regular14
                          .copyWith(color: AppColors.primary),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: subTittle, style: AppTextStyles.regular14),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

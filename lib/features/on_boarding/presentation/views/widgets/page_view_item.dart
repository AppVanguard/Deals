import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    required this.tittle,
    required this.subTittle,
    required this.subTittleFirst,
  });
  final String image, tittle, subTittleFirst, subTittle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image),
        SizedBox(
          height: 20,
        ),
        Text(
          tittle,
          style: AppTextStyles.bold22,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: subTittleFirst,
                  style: AppTextStyles.regular14
                      .copyWith(color: AppColors.primary)),
              TextSpan(
                text: ' ',
              ),
              TextSpan(text: subTittle, style: AppTextStyles.regular14),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

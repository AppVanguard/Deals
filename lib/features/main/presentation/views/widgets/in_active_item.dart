import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

/// Displayed for non-selected navigation items with gray styling.
class InActiveItem extends StatelessWidget {

  const InActiveItem({super.key, required this.image, required this.title});
  final String image;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(image),
        const SizedBox(height: 2),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.semiBold12.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

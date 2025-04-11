import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ActivatedBar extends StatelessWidget {
  const ActivatedBar({
    super.key,
    required this.onPressed,
    this.discountValue,
    this.storeTittle,
    this.imageUrl,
  });

  final VoidCallback onPressed;
  final String? imageUrl;
  final String? discountValue;
  final String? storeTittle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Store icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Skeletonizer(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: AppColors.tertiaryText,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.tertiaryText,
                        child: const Icon(
                          Icons.image,
                          size: 32,
                        ),
                      ),
                    )
                  : Image.asset(
                      AppImages.assetsImagesTest1,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${S.of(context).upTo} $discountValue%',
                  style: AppTextStyles.semiBold14.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: ' ${S.of(context).isActivatedNow}',
                  style: AppTextStyles.regular14,
                ),
              ],
            ),
          ), // Check icon
          SvgPicture.asset(
            AppImages.assetsImagesSuccess,
            width: 28,
            height: 28,
          ),

          // Custom button
          CustomButton(
            width: double.infinity,
            onPressed: onPressed,
            text: '${S.of(context).continueTo} $storeTittle',
          ),
        ],
      ),
    );
  }
}

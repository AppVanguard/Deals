import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

/// CTA bar displayed at the bottom of store pages.
/// Shows a shop button and optional cashback text.
class ShopNowBar extends StatelessWidget {
  const ShopNowBar({
    super.key,
    required this.onPressed,
    this.discountValue,
  });

  final VoidCallback onPressed;
  final String? discountValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      // No fixed height – it adjusts to its children.
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Shop now and get X% cashback"
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: S.of(context).shopNowAndGet,
              style: AppTextStyles.regular14.copyWith(
                color: AppColors.text,
              ),
              children: [
                TextSpan(
                  text: '$discountValue% ${S.of(context).cashBack}',
                  style: AppTextStyles.semiBold14.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: onPressed,
            text: S.of(context).shopNow,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

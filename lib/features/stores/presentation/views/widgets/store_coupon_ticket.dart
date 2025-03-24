import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/coupon_ticket/ticket_container.dart';
import '../../../../../core/widgets/coupon_ticket/dashed_line_painter.dart';

/// A specialized coupon widget that uses [TicketContainer].
/// This widget takes coupon-related data and uses the ticket container to display it.
class StoreCouponTicket extends StatelessWidget {
  final num discountValue;
  final String? imageUrl;
  final DateTime? expiryDate;
  final String buttonText;
  final String expirationText;
  final Color buttonColor;

  /// List of terms to display under the discount value
  final List<String>? terms;

  /// Sizing
  final double? width;
  final double? height;

  /// Callback for the trailing icon button
  final VoidCallback? onPressed;

  const StoreCouponTicket({
    super.key,
    required this.discountValue,
    required this.buttonText,
    required this.expirationText,
    required this.buttonColor,
    this.imageUrl,
    this.expiryDate,
    this.width,
    this.height = 120,
    this.onPressed,
    this.terms,
  });

  @override
  Widget build(BuildContext context) {
    return TicketContainer(
      holeRadius: 16,
      dashedLinePainter: const DashedLinePainter(
        dashHeight: 8,
        dashSpace: 4,
        strokeWidth: 2,
      ),
      centerLine: true, // places the dashed line between leading & child
      spacing: 20, // Adjust for better alignment
      width: width,
      height: height,
      leading: _buildLeadingContent(context),
      child: _buildGetCodeButton(),
    );
  }

  // Builds the leading content (discount text + bullet terms).
  Widget _buildLeadingContent(BuildContext context) {
    // 1) Convert your list of terms into a single string with line breaks.
    //    Each bullet is on its own line, e.g. "• Term1\n• Term2\n• Term3"
    final bulletText = (terms != null && terms!.isNotEmpty)
        ? terms!.map((term) => '• $term').join('\n')
        : '';

    return SizedBox(
      width: width! * .6,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Extra top padding if desired
            const SizedBox(height: 8),

            // Discount text (truncate to 1 line if it's really long)
            Text(
              "${S.current.ExtraDiscountTo} $discountValue%",
              style: AppTextStyles.bold14.copyWith(
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Terms as a single multi-line text block
            if (bulletText.isNotEmpty)
              Text(
                bulletText,
                style: AppTextStyles.regular13.copyWith(
                  color: AppColors.secondaryText,
                ),
                // Limit the number of lines to prevent overflow
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  // Builds the "Get Code" button and expiration text.
  Widget _buildGetCodeButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 118,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: buttonColor,
                        ),
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText,
                          style: AppTextStyles.bold14.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 118,
                  child: Text(
                    expirationText,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular13.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

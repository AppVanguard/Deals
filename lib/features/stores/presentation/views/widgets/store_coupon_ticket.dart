import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/coupon_ticket/ticket_container.dart';
import '../../../../../core/widgets/coupon_ticket/dashed_line_painter.dart';

/// A specialized coupon widget that uses [TicketContainer].
/// This widget takes coupon-related data and uses the ticket container to display it.
class StoreCouponTicket extends StatelessWidget {
  final String title;
  final String code;
  final num? discountValue;
  final String? imageUrl;
  final DateTime? expiryDate;
  final String buttonText; // Dynamic button text
  final String expirationText; // Dynamic expiration text
  final Color buttonColor;

  /// Sizing
  final double? width;
  final double? height;

  /// Callback for the trailing icon button
  final VoidCallback? onPressed;

  const StoreCouponTicket({
    super.key,
    required this.title,
    required this.code,
    required this.buttonText,
    required this.expirationText,
    this.discountValue,
    this.imageUrl,
    this.expiryDate,
    this.width,
    this.height = 120,
    this.onPressed,
    required this.buttonColor,
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
      spacing: 20, // Adjusted for better alignment
      width: width,
      height: height,
      leading: _buildLeadingContent(),
      child: _buildGetCodeButton(),
    );
  }

  // Builds the leading content, including title and description.
  Widget _buildLeadingContent() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
            width! * 0.6, // Restrict leading content to 60% of the ticket width
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bold14.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Text(code,
              style: AppTextStyles.regular13.copyWith(
                color:
                    AppColors.secondaryText, // Grey color for the description
                overflow: TextOverflow.ellipsis,
              )),
          const SizedBox(height: 8),
          if (discountValue != null)
            Text('$discountValue% OFF',
                style: AppTextStyles.bold14.copyWith(
                  color: AppColors.accent, // Red color for the discount value
                )),
        ],
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
                // Get Code Button with dynamic button text
                GestureDetector(
                  onTap: onPressed, // Dynamic onPressed callback
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: buttonColor, // Red border
                        ),
                        borderRadius:
                            BorderRadius.circular(21), // Rounded corners
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText, // Dynamic button text
                          style: AppTextStyles.bold14.copyWith(
                            color: AppColors
                                .accent, // Red color for the button text
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Spacing between button and text

                // Expiration text with dynamic content
                SizedBox(
                  width: 118,
                  child: Text(
                    expirationText, // Dynamic expiration text
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

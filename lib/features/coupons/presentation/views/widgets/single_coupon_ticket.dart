import 'package:flutter/material.dart';
import 'package:deals/core/widgets/coupon_ticket/dashed_line_painter.dart';
import 'package:deals/core/widgets/coupon_ticket/ticket_container.dart';

// Example colors and text styles - replace with your own
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

class SingleCouponTicket extends StatelessWidget {
  final String code;
  final String? imageUrl;

  /// Shown at the top, e.g. "Alibaba.com".
  final String mainTitle;

  /// Middle title or short subtitle, e.g. "Lorem ipsum dolor sit amet..."
  final String description;

  /// Bullet points
  final List<String> bulletPoints;

  /// Expiration display text, e.g. "Expires in 14 days"
  final String expirationText;

  /// The label shown on the code or near the code
  final String codeLabel;

  /// The main call-to-action button text, e.g. "Shop now and get up to 20% cashback"
  final String ctaButtonText;

  /// Color for the main CTA button background
  final Color ctaButtonColor;

  /// Callback for "Copy code" button
  final VoidCallback? onCopyCode;

  /// Callback for CTA button
  final VoidCallback? onCtaPressed;

  /// Overall sizing
  final double? width;
  final double? height;

  const SingleCouponTicket({
    super.key,
    required this.mainTitle,
    required this.description,
    required this.bulletPoints,
    required this.expirationText,
    required this.code,
    required this.codeLabel,
    required this.ctaButtonText,
    required this.ctaButtonColor,
    this.onCopyCode,
    this.onCtaPressed,
    this.imageUrl,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return TicketContainer(
      // Force vertical layout so holes are at top & bottom
      horizontalLayout: false,
      holeRadius: 16,
      // Places dashed line between leading & child
      centerLine: true,
      dashedLinePainter: const DashedLinePainter(
        dashHeight: 16,
        dashSpace: 4,
        strokeWidth: 2,
      ),
      // width: width ?? MediaQuery.of(context).size.width * 0.8,
      // height: height ?? 400,
      // Top portion
      leading: _buildLeadingSection(context),
      // Bottom portion (CTA button)
      trailing: _buildTrailingSection(context),
      // Middle portion (the code row)
      child: _buildCodeSection(context),
    );
  }

  // Top: logo, main title, description, bullet points, expiration
  Widget _buildLeadingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // If you have an image/logo:
          if (imageUrl != null) ...[
            Image.asset(
              imageUrl!,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
          ],

          // Main Title
          Text(
            mainTitle,
            style: AppTextStyles.bold16.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            description,
            style: AppTextStyles.regular14.copyWith(color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Bullet points
          ...bulletPoints.map(
            (bullet) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  child: Text(
                    bullet,
                    style: AppTextStyles.regular13.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Expiration
          Text(
            expirationText,
            style: AppTextStyles.regular13.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // Middle: The code and "Copy code" button
  Widget _buildCodeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // The code in a container
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white70,
            ),
            child: Text(
              code,
              style: AppTextStyles.bold14.copyWith(color: Colors.black),
            ),
          ),

          const SizedBox(height: 8),

          // Copy code button
          GestureDetector(
            onTap: onCopyCode,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                codeLabel,
                style: AppTextStyles.bold14.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom: The large CTA button
  Widget _buildTrailingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onCtaPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: ctaButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(
            ctaButtonText,
            style: AppTextStyles.bold16.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

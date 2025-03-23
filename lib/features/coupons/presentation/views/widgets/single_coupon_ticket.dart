import 'package:cached_network_image/cached_network_image.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/coupon_ticket/dashed_line_painter.dart';
import 'package:deals/core/widgets/coupon_ticket/ticket_container.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:skeletonizer/skeletonizer.dart';

class SingleCouponTicket extends StatefulWidget {
  final String code;
  final String? imageUrl;

  /// Middle title or short subtitle, e.g. "Lorem ipsum..."
  final String description;

  /// Bullet points
  final List<String> bulletPoints;

  /// Expiration display text, e.g. "Expires in 14 days"
  final String expirationText;

  /// The label shown on the code or near the code (e.g. "Copy code")
  final String codeLabel;

  /// The main call-to-action button text, e.g. "Shop now and get 20%..."
  final String ctaButtonText;

  /// Color for the main CTA button background
  final Color ctaButtonColor;

  /// Callback for CTA button
  final VoidCallback onCtaPressed;

  /// Overall sizing
  final double? width;
  final double? height;

  const SingleCouponTicket({
    super.key,
    required this.code,
    required this.description,
    required this.bulletPoints,
    required this.expirationText,
    required this.codeLabel,
    required this.ctaButtonText,
    required this.ctaButtonColor,
    this.imageUrl,
    required this.onCtaPressed,
    this.width,
    this.height,
  });

  @override
  State<SingleCouponTicket> createState() => _SingleCouponTicketState();
}

class _SingleCouponTicketState extends State<SingleCouponTicket> {
  /// Whether the code has just been copied
  bool _copied = false;

  /// Copy the code to the clipboard, then switch the button to "Copied"
  Future<void> _handleCopyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() {
      _copied = true;
    });
    // Optional: revert back to "Copy code" after a delay
    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() => _copied = false);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return TicketContainer(
      spacing: 16,
      elevation: 15,
      horizontalLayout: false, // vertical ticket layout
      holeRadius: 36,
      centerLine: true,
      dashedLinePainter: const DashedLinePainter(
        dashHeight: 16,
        dashSpace: 4,
        strokeWidth: 2,
      ),
      width: widget.width,
      height: widget.height,
      leading: _buildLeadingSection(context),
      trailing: _buildTrailingSection(context),
      child: _buildCodeSection(context),
    );
  }

  /// Top portion: image, description, bullet points, and expiration text
  Widget _buildLeadingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 60),
          if (widget.imageUrl != null) ...[
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(
                    child: Container(
                      width: 160,
                      height: 160,
                      color: AppColors.tertiaryText,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 160,
                    height: 160,
                    color: AppColors.tertiaryText,
                    child: const Icon(
                      Icons.image,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            SizedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: AppColors.tertiaryText,
                  width: 160,
                  height: 160,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: AppTextStyles.bold15,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ...widget.bulletPoints.map((bullet) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: AppTextStyles.regular14),
                Expanded(
                  child: Text(
                    bullet,
                    style: AppTextStyles.regular13.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 8),
          Text(
            widget.expirationText,
            style: AppTextStyles.regular13.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  /// Middle portion: code + "copy" button or "Copied" button
  Widget _buildCodeSection(BuildContext context) {
    final bool isCopied = _copied;
    final String buttonText = isCopied ? 'Copied' : widget.codeLabel;
    final Color buttonColor = isCopied ? Colors.green : const Color(0xFF1D241F);
    final IconData buttonIcon = isCopied ? Icons.done_all : Icons.copy;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEEF0EE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.code,
                        style: const TextStyle(
                          color: Color(0xFF1D241F),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _handleCopyCode,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: buttonColor,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buttonText,
                          style: TextStyle(
                            color: buttonColor,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          buttonIcon,
                          size: 16,
                          color: buttonColor,
                        ),
                      ],
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

  /// Bottom portion: CTA button and extra spacing
  Widget _buildTrailingSection(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          onPressed: widget.onCtaPressed,
          text: widget.ctaButtonText,
          width: double.infinity,
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

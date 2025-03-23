import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../../core/widgets/coupon_ticket/ticket_container.dart';
import '../../../../../core/widgets/coupon_ticket/dashed_line_painter.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A specialized coupon widget that uses [TicketContainer].
/// Here we accept coupon-related data.
class CouponsCouponTicket extends StatelessWidget {
  final String title;
  final num? discountValue;
  final String? imageUrl;
  final DateTime? expiryDate;
  final bool active;

  /// Sizing
  final double? width;
  final double? height;

  /// Callback for the trailing icon button
  final VoidCallback? onPressed;

  const CouponsCouponTicket({
    super.key,
    required this.title,
    this.discountValue,
    this.imageUrl,
    this.expiryDate,
    this.width,
    this.height = 120,
    this.onPressed,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return TicketContainer(
      elevation: 15,
      onTap: onPressed,
      holeRadius: 16,
      dashedLinePainter: const DashedLinePainter(
        dashHeight: 10,
        dashSpace: 4,
        strokeWidth: 2,
        color: Colors.black,
      ),
      centerLine: true, // places the dashed line between leading & child
      spacing: 25,
      height: height,
      leading: _buildLeadingImage(),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.accent,
        size: 32,
      ),
      child: _buildCouponInfo(),
    );
  }

  Widget _buildLeadingImage() {
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80),
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            fit: BoxFit.contain,
            placeholder: (ctx, url) => Skeletonizer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 66,
                  height: 66,
                  color: AppColors.lightGray,
                ),
              ),
            ),
            errorWidget: (ctx, url, error) => const Icon(
              Icons.image,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.isNotEmpty ? title : 'Placeholder Title',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${S.current.Get} ',
                style: AppTextStyles.semiBold12,
              ),
              TextSpan(
                text: '${discountValue ?? 0}% ${S.current.off}',
                style: AppTextStyles.semiBold12.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          active
              ? expiryDate != null
                  ? 'Valid until ${DateFormat('d MMM').format(expiryDate!)}'
                  : 'Valid until ...'
              : S.current.Expired,
          style: AppTextStyles.regular12.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

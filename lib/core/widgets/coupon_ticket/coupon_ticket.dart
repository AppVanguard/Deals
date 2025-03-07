import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/widgets/coupon_ticket/dashed_line_painter.dart';
import 'package:deals/core/widgets/coupon_ticket/rect_ticket_clipper.dart';

class CouponTicket extends StatelessWidget {
  final CouponEntity coupon;
  final bool isLoading;

  /// Optional width can be provided; otherwise defaults to 85% of screen width.
  final double? width;
  final double height;

  const CouponTicket({
    super.key,
    required this.coupon,
    this.isLoading = false,
    this.width,
    this.height = 130.0,
  });

  // Helper method to parse and format the expiry date.
  String _formattedDate() {
    if (coupon.expiryDate != null) {
      final parsed = DateTime.tryParse(coupon.expiryDate!);
      if (parsed != null) {
        return DateFormat('d MMM').format(parsed);
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? MediaQuery.of(context).size.width * 0.8;
    final formattedDate = _formattedDate();

    return Skeletonizer(
      enabled: isLoading,
      child: PhysicalShape(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        color: Colors.white,
        clipper: const RectTicketClipper(holeRadius: 16),
        child: SizedBox(
          width: cardWidth,
          height: height,
          child: Row(
            children: [
              const SizedBox(width: 12),
              CouponBrandImage(coupon: coupon),
              SizedBox(
                height: height * 0.8,
                child: const CustomPaint(
                  painter: DashedLinePainter(
                    color: AppColors.secondaryText,
                    dashHeight: 11,
                    dashSpace: 8,
                    strokeWidth: 2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // The CouponInfoSection now has extra right padding
              // and uses Flexible for each text so that long text wraps.
              Expanded(
                child: CouponInfoSection(
                  coupon: coupon,
                  formattedDate: formattedDate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CouponBrandImage extends StatelessWidget {
  final CouponEntity coupon;

  const CouponBrandImage({
    super.key,
    required this.coupon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        width: 66,
        height: 66,
        child: Image.network(
          coupon.id,
          fit: BoxFit.contain,
          errorBuilder: (ctx, error, stack) => Image.asset(
            AppImages.assetsImagesTest2,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class CouponInfoSection extends StatelessWidget {
  final CouponEntity coupon;
  final String formattedDate;

  const CouponInfoSection({
    super.key,
    required this.coupon,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final discountText = coupon.validForExisting ?? false
        ? S.of(context).existing_customers_discount
        : coupon.validForNew ?? false
            ? S.of(context).new_customers_discount
            : S.of(context).specific_items_discount;

    return Padding(
      // Adding extra right padding (16) keeps text away from the right clip hole.
      padding: const EdgeInsets.only(
          left: 8.0, right: 16.0, top: 12.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              coupon.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              softWrap: true,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: discountText, style: AppTextStyles.semiBold12),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: '${coupon.discountValue}% off',
                    style: AppTextStyles.semiBold12.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              softWrap: true,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              formattedDate.isNotEmpty
                  ? '${S.of(context).valid_until} $formattedDate'
                  : 'valid until ...',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

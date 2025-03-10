import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/widgets/coupon_ticket/dashed_line_painter.dart';
import 'package:deals/core/widgets/coupon_ticket/rect_ticket_clipper.dart';

class CouponTicket extends StatelessWidget {
  final bool isLoading;
  final String? image, tittle, subTittle;
  final int? discountValue;
  final String? validTo;

  /// Optional width can be provided; otherwise defaults to 85% of screen width.
  final double? width;
  final double height;

  const CouponTicket({
    super.key,
    this.isLoading = false,
    this.width,
    this.height = 130.0,
    this.validTo,
    this.image,
    this.tittle,
    this.subTittle,
    this.discountValue,
  });

  // Helper method to parse and format the expiry date.
  String _formattedDate() {
    if (validTo != null) {
      final parsed = DateTime.tryParse(validTo!);
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
              CouponBrandImage(
                image: image,
              ),
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
                  discountValue: discountValue,
                  tittle: tittle,
                  subTittle: subTittle,
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
  final String? image;
  const CouponBrandImage({
    super.key,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        width: 66,
        height: 66,
        child: Image.network(
          image ?? '',
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
  final String formattedDate;
  final String? tittle;
  final String? subTittle;
  final int? discountValue;
  const CouponInfoSection({
    this.discountValue,
    this.subTittle,
    super.key,
    this.tittle,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adding extra right padding (16) keeps text away from the right clip hole.
      padding: const EdgeInsets.only(
          left: 8.0, right: 16.0, top: 12.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              tittle ?? '',
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
                  TextSpan(text: subTittle, style: AppTextStyles.semiBold12),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: '$discountValue% off',
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

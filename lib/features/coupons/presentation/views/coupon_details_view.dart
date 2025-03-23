import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupon_details_cubit/coupon_detail_cubit.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/coupons/presentation/views/widgets/single_coupon_ticket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CouponDetailsView extends StatelessWidget {
  const CouponDetailsView({super.key, required this.couponId});
  static const routeName = '/coupon_details';
  final String couponId;

  /// Helper method to build expiration text based on [expiryDate]
  String _buildExpirationText(DateTime? expiryDate) {
    if (expiryDate == null) {
      return '';
    }
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;
    if (difference <= 0) {
      return S.current.Expired;
    } else {
      final dayString = difference == 1 ? S.current.day : S.current.days;
      return '${S.current.ExpiresIn} $difference $dayString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponDetailCubit, CouponDetailState>(
      builder: (context, state) {
        if (state is CouponDetailInitial) {
          context.read<CouponDetailCubit>().getCouponById(couponId);
        }
        if (state is CouponDetailFailure) {
          return buildCustomErrorScreen(
            context: context,
            onRetry: () {
              context.read<CouponDetailCubit>().getCouponById(couponId);
            },
          );
        }
        final coupon = state is CouponDetailSuccess ? state.coupon : null;
        return Skeletonizer(
          enabled: state is CouponDetailLoading || state is CouponDetailInitial,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleCouponTicket(
                    // Use the helper to build expiration text:
                    expirationText: coupon != null
                        ? _buildExpirationText(coupon.expiryDate)
                        : 'Loading...',
                    description: coupon?.description ??
                        'Lorem ipsum dolor sit amet consectetur.\nPellentesque sed turpis cursus suspendisse sapien augue.',
                    bulletPoints: coupon?.termsAndConditions ??
                        const [
                          'applied only if you purchase above 600\$',
                          'offer might end before the specialized date',
                          'applied only if you purchase above 600\$',
                          'offer might end before the specialized date',
                          'applied only if you purchase above 600\$',
                          'offer might end before the specialized date',
                          'applied only if you purchase above 600\$',
                          'offer might end before the specialized date',
                          'applied only if you purchase above 600\$',
                        ],
                    code: coupon?.code ?? 'Loading...',
                    codeLabel: S.of(context).copyCode,
                    ctaButtonText:
                        '${S.of(context).shopNowAndGet} ${S.of(context).upTo} ${coupon?.cashBak ?? 0}% ${S.of(context).cashBack}',
                    ctaButtonColor: Colors.green,
                    // Example image
                    imageUrl: coupon?.image,
                    onCtaPressed: () {
                      // TODO: navigate or show some action
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

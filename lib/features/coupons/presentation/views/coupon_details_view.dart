import 'package:deals/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/coupons/presentation/views/widgets/single_coupon_ticket.dart';

class CouponDetailsView extends StatelessWidget {
  const CouponDetailsView({super.key, required this.couponId});
  static const routeName = '/coupon_details';
  final String couponId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Coupon Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleCouponTicket(
            // Example values to replicate the screenshot
            mainTitle: 'Alibaba.com',
            description:
                'Lorem ipsum dolor sit amet consectetur.\nPellentesque sed turpis cursus suspendisse sapien augue.',
            bulletPoints: const [
              'offer might end before the specialized date',
              'applied only if you purchase above 600\$',
            ],
            expirationText: 'Expires in 14 days',
            code: 'Z23C567',
            codeLabel: 'Copy code',
            ctaButtonText: 'Shop now and get up to 20% cashback',
            ctaButtonColor: Colors.green,
            // Example image
            imageUrl: AppImages.assetsImagesTest1,
            onCopyCode: () {
              // TODO: copy code to clipboard
            },
            onCtaPressed: () {
              // TODO: navigate or show some action
            },
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
          ),
        ),
      ),
    );
  }
}

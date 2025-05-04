import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class DeletedSuccessScreen extends StatelessWidget {
  const DeletedSuccessScreen({super.key});
  static const String routeName = '/deleted-success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            SvgPicture.asset(
              AppImages.assetsImagesSuccess,
              width: 56,
              height: 56,
            ),
            const SizedBox(height: 24),
            Text(
              S.of(context).accountDeletedSuccessfully,
              style: AppTextStyles.bold22,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                S.of(context).accountDeleted,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular14,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to your registration/sign-up route.
                  context.goNamed(SigninView.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  S.of(context).goToRegistration,
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

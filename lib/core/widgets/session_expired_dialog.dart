import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/auth/presentation/views/signin/signin_view.dart';

/// Dialog shown when the auth token is invalid/expired.
class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 298,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: ShapeDecoration(
          color: AppColors.background,
          shadows: const [
            BoxShadow(color: Color(0x3F000000), blurRadius: 6),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppImages.assetsImagesWarning),
            const SizedBox(height: 16),
            Text(
              s.sessionExpired,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D241F),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.goNamed(SigninView.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                s.Login,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

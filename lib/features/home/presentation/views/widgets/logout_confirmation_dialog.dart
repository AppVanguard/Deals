import 'package:deals/core/widgets/app_confirmation_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/generated/l10n.dart';

class LogoutConfirmationDialog extends AppConfirmationDialog {
  LogoutConfirmationDialog({super.key, required S s})
      : super(
          icon: SvgPicture.asset(AppImages.assetsImagesLogOut, height: 28),
          title: s.logOut,
          message: s.areYouSureYouWantToLogout,
          cancelLabel: s.cancel,
          confirmLabel: s.logOut,
          confirmColor: AppColors.accent, // #D12825
        );
}

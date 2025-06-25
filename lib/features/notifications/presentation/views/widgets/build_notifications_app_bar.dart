import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Basic app bar used on the notifications screen.
AppBar buildNotificationsAppBar(BuildContext context) {
  return AppBar(
    title: Text(S.of(context).Notifications),
    centerTitle: true,
    backgroundColor: AppColors.background,
    elevation: 0,
  );
}

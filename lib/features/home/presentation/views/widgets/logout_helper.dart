import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/generated/l10n.dart';
import '../../manager/cubits/menu_cubit/menu_cubit.dart';
import 'logout_confirmation_dialog.dart';

/// Displays a confirmation dialog and triggers logout via [MenuCubit].
Future<void> confirmAndLogout({
  required BuildContext context,
  required UserEntity user,
}) async {
  final s = S.of(context);
  final approved = await showDialog<bool>(
    context: context,
    builder: (_) => LogoutConfirmationDialog(s: s),
  );

  if (approved == true && context.mounted) {
    context.read<MenuCubit>().logout(
          firebaseUid: user.uId,
          authToken: user.token,
        );
  }
}

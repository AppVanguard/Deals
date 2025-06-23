import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/helper_functions/app_router.dart';
import 'package:deals/core/widgets/session_expired_dialog.dart';
import 'package:deals/core/manager/cubit/session_cubit/session_cubit.dart';

/// Handles global session related actions like showing the session expired dialog.
class SessionManager {
  static void handleUnauthorized() {
    final ctx = AppRouter.navigatorKey.currentContext;
    if (ctx == null) return;
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: ctx.read<SessionCubit>(),
        child: const SessionExpiredDialog(),
      ),
    );
  }
}

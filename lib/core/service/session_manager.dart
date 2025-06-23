import 'package:flutter/material.dart';
import 'package:deals/core/helper_functions/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/cubit/session_cubit/session_cubit.dart';
import 'package:deals/core/widgets/session_expired_dialog.dart';

/// Handles global session related actions like showing the session expired dialog.
class SessionManager {
  static void handleUnauthorized() {
    final ctx = AppRouter.navigatorKey.currentContext;
    if (ctx == null) return;
    final cubit = BlocProvider.of<SessionCubit>(ctx, listen: false);
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const SessionExpiredDialog(),
      ),
    );
  }
}

// lib/features/settings/presentation/views/settings_view.dart

import 'package:deals/constants.dart';
import 'package:deals/features/settings/presentation/manager/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'widgets/settings_view_body.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text(s.settings, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (ctx, state) {
          final isLoading = state is SettingsLoading;

          String? errorMessage;
          if (state is SettingsPushFailure ||
              state is SettingsChangePasswordFailure ||
              state is SettingsDeleteAccountFailure) {
            errorMessage = (state as dynamic).message as String;
          }

          // Determine current toggle value:
          bool pushEnabled;
          if (state is SettingsPushSuccess) {
            pushEnabled = state.isEnabled;
          } else {
            // on first load, read saved preference (default true)
            pushEnabled = Prefs.getBool(kPushEnabled);
          }

          return SettingsViewBody(
            pushEnabled: pushEnabled,
            isLoading: isLoading,
            onTogglePush: (val) => ctx.read<SettingsCubit>().togglePush(val),
            errorMessage: errorMessage,
          );
        },
      ),
    );
  }
}

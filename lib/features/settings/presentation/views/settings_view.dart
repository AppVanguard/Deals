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

          return const SettingsViewBody();
        },
      ),
    );
  }
}

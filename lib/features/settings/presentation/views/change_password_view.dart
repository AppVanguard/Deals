// lib/features/settings/presentation/views/change_password_view.dart

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/settings/domain/repos/settings_repo.dart';
import 'package:deals/features/settings/presentation/manager/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/settings/presentation/views/widgets/change_password_bloc_consumer.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});
  static const routeName = '/change-password';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.changePassword),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: BlocProvider(
        create: (_) => SettingsCubit(repo: getIt<SettingsRepo>()),
        child: const ChangePasswordBlocConsumer(),
      ),
    );
  }
}

import 'package:deals/features/settings/presentation/manager/settings_cubit.dart';
import 'package:deals/features/settings/presentation/views/widgets/deleted_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/features/settings/presentation/views/widgets/delete_account_view_body.dart';
import 'package:deals/features/settings/presentation/views/widgets/delete_account_dialog.dart';
import 'package:deals/features/settings/presentation/manager/cubits/delete_reasons_cubit/delete_reasons_cubit.dart';
import 'package:deals/features/settings/data/repos/delete_account_repository.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});
  static const String routeName = '/settings/delete-account';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocProvider(
      create: (_) =>
          DeleteReasonsCubit(repository: JsonDeleteAccountRepository())
            ..loadReasons(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          title: Text(
            s.deleteAccount,
            style: AppTextStyles.bold18.copyWith(color: AppColors.accent),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (ctx, state) {
            if (state is SettingsDeleteAccountSuccess) {
              context.goNamed(DeletedSuccessScreen.routeName);
            }
          },
          builder: (ctx, state) {
            final isLoading = state is SettingsLoading;
            final errorMessage =
                state is SettingsDeleteAccountFailure ? state.message : null;
            return DeleteAccountViewBody(
              isLoading: isLoading,
              errorMessage: errorMessage,
              onDelete: () {
                // show the clean dialog:
                showDialog(
                  context: context,
                  builder: (_) => DeleteAccountDialog(
                    onConfirm: () async {
                      final user = await SecureStorageService.getCurrentUser();
                      if (user == null) return;
                      if (!context.mounted) return;
                      ctx.read<SettingsCubit>().deleteAccount(
                            firebaseUid: user.uId,
                            authToken: user.token,
                          );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

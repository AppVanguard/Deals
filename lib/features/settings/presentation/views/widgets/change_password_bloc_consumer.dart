import 'dart:async';

import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/features/settings/presentation/manager/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/settings/presentation/views/widgets/change_password_view_body.dart';

/// Provides state handling for the change password form.
class ChangePasswordBlocConsumer extends StatelessWidget {
  const ChangePasswordBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (ctx, state) async {
        final messenger = ScaffoldMessenger.of(ctx);

        // On success: show a custom MaterialBanner
        if (state is SettingsChangePasswordSuccess) {
          // 1) hide any existing banner
          messenger.hideCurrentMaterialBanner();

          // 2) show our custom banner
          messenger.showMaterialBanner(
            MaterialBanner(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              content: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(
                  color: Color(0xFFE8FFF0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // your green success icon
                    SvgPicture.asset(
                      AppImages.assetsImagesSuccess,
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(ctx).passwordChangedSuccessfully,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF04832D),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // banner requires at least one action, so we add a no-op
              actions: const [SizedBox.shrink()],
            ),
          );

          // 3) auto‐dismiss after 2 seconds
          Timer(const Duration(seconds: 2), () {
            messenger.hideCurrentMaterialBanner();
          });
        }

        // On failure just hide any banner
        if (state is SettingsChangePasswordFailure) {
          messenger.hideCurrentMaterialBanner();
        }
      },
      builder: (ctx, state) {
        final isLoading = state is SettingsLoading;
        final errorMessage =
            state is SettingsChangePasswordFailure ? state.message : null;
        return ChangePasswordViewBody(
          isLoading: isLoading,
          errorMessage: errorMessage,
          onSubmit: (oldPwd, newPwd) async {
            // fetch stored user
            final user = await SecureStorageService.getCurrentUser();
            if (user == null) return;
            if (!context.mounted) return;
            await ctx.read<SettingsCubit>().changePassword(
                  email: user.email,
                  currentPassword: oldPwd,
                  newPassword: newPwd,
                  authToken: user.token,
                );
          },
        );
      },
    );
  }
}

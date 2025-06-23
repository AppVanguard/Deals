import 'package:deals/core/widgets/coming_soon_toast.dart';
import 'package:deals/features/settings/presentation/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:deals/generated/l10n.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/app_version_text.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/entities/user_entity.dart';

import 'package:deals/features/auth/presentation/views/signin/signin_view.dart';
import 'package:deals/features/home/presentation/manager/cubits/menu_cubit/menu_cubit.dart';
import 'package:deals/features/personal_data/presentation/views/personal_data_view.dart';
import 'package:deals/features/terms_and_conditions/presentations/views/terms_and_conditions_view.dart';
import 'package:deals/features/privacy_and_policy/presentation/views/privacy_and_policy_view.dart';
import 'package:deals/features/faq/presentation/views/faq_view.dart';

import 'drawer_divider.dart';
import 'drawer_tile.dart';
import 'logout_helper.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key, required this.userData});
  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: size.height * 0.80,
        width: size.width * 0.80,
        child: Drawer(
          backgroundColor: AppColors.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: FutureBuilder<UserEntity?>(
            future: SecureStorageService.getCurrentUser(),
            builder: (ctx, snap) {
              final user = snap.data ?? userData;

              if (snap.connectionState != ConnectionState.done &&
                  snap.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  // ───────────── HEADER ─────────────
                  Container(
                    color: AppColors.darkPrimary,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(user.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),

                  // ───────────── BODY ─────────────
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DrawerTile(
                            icon: AppImages.assetsImagesEarning,
                            text: s.earnings,
                            onTap: () =>
                                showComingSoonToast(context, s.earnings),
                          ),
                          DrawerTile(
                            icon: AppImages.assetsImagesPersonalData,
                            text: s.personalData,
                            onTap: () => context.pushNamed(
                              PersonalDataView.routeName,
                              extra: user.uId,
                            ),
                          ),
                          const DrawerDivider(),
                          DrawerTile(
                            icon: AppImages.assetsImagesTermsConditions,
                            text: s.termsAndConditions,
                            onTap: () => context.pushNamed(
                              TermsAndConditionsView.routeName,
                            ),
                          ),
                          DrawerTile(
                            icon: AppImages.assetsImagesPrivacyIcon,
                            text: s.privacyPolicy,
                            onTap: () => context.pushNamed(
                              PrivacyAndPolicyView.routeName,
                            ),
                          ),
                          DrawerTile(
                            icon: AppImages.assetsImagesSettings,
                            text: s.settings,
                            onTap: () =>
                                context.pushNamed(SettingsView.routeName),
                          ),
                          const DrawerDivider(),
                          DrawerTile(
                            icon: AppImages.assetsImagesHelp,
                            text: s.help,
                            onTap: () => context.pushNamed(FAQView.routeName),
                          ),
                          DrawerTile(
                            icon: AppImages.assetsImagesContact,
                            text: s.contactUs,
                            onTap: () =>
                                showComingSoonToast(context, s.contactUs),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ───────────── FOOTER ─────────────
                  BlocListener<MenuCubit, MenuState>(
                    listener: (ctx, state) {
                      if (state is MenuLogoutFailure) {
                        customErrorTopSnackBar(
                          context: ctx,
                          message: state.message,
                        );
                      } else if (state is MenuLogoutSuccess) {
                        ctx.goNamed(SigninView.routeName);
                      }
                    },
                    child: DrawerTile(
                      icon: AppImages.assetsImagesLogOut,
                      text: s.logOut,
                      textStyle:
                          AppTextStyles.bold14.copyWith(color: AppColors.accent),
                      onTap: () =>
                          confirmAndLogout(context: context, user: user),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: AppVersionText(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}

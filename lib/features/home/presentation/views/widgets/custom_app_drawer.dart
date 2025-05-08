import 'package:deals/features/settings/presentation/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:deals/generated/l10n.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/app_version_text.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/entities/user_entity.dart';

import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/home/presentation/manager/cubits/menu_cubit/menu_cubit.dart';
import 'package:deals/features/personal_data/presentation/views/personal_data_view.dart';
import 'package:deals/features/terms_and_conditions/presentations/views/terms_and_conditions_view.dart';
import 'package:deals/features/privacy_and_policy/presentation/views/privacy_and_policy_view.dart';
import 'package:deals/features/faq/presentation/views/faq_view.dart';

import 'logout_confirmation_dialog.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key, required this.userData});
  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final size = MediaQuery.of(context).size;

    Future<void> confirmAndLogout(UserEntity user) async {
      final approved = await showDialog<bool>(
        context: context,
        builder: (_) => LogoutConfirmationDialog(s: s),
      );
      if (approved == true) {
        if (!context.mounted) return; // ignore: unnecessary_null_awareness
        context.read<MenuCubit>().logout(
              firebaseUid: user.uId,
              authToken: user.token,
            );
      }
    }

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: size.height * 0.80,
        width: size.width * 0.80,
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: FutureBuilder<UserEntity?>(
            future: SecureStorageService.getCurrentUser(),
            builder: (ctx, snap) {
              // Use secure-storage copy if present; else fall back to in-memory.
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
                          _tile(
                            icon: AppImages.assetsImagesEarning,
                            text: s.earnings,
                            onTap: () {},
                          ),
                          _tile(
                            icon: AppImages.assetsImagesPersonalData,
                            text: s.personalData,
                            onTap: () => context.pushNamed(
                              PersonalDataView.routeName,
                              extra: user.uId,
                            ),
                          ),
                          _divider(),
                          _tile(
                            icon: AppImages.assetsImagesTermsConditions,
                            text: s.termsAndConditions,
                            onTap: () => context.pushNamed(
                              TermsAndConditionsView.routeName,
                            ),
                          ),
                          _tile(
                            icon: AppImages.assetsImagesPrivacyIcon,
                            text: s.privacyPolicy,
                            onTap: () => context.pushNamed(
                              PrivacyAndPolicyView.routeName,
                            ),
                          ),
                          _tile(
                            icon: AppImages.assetsImagesSettings,
                            text: s.settings,
                            onTap: () {
                              context.pushNamed(SettingsView.routeName);
                            },
                          ),
                          _divider(),
                          _tile(
                            icon: AppImages.assetsImagesHelp,
                            text: s.help,
                            onTap: () => context.pushNamed(
                              FAQView.routeName,
                            ),
                          ),
                          _tile(
                            icon: AppImages.assetsImagesContact,
                            text: s.contactUs,
                            onTap: () {},
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
                    child: _tile(
                      icon: AppImages.assetsImagesLogOut,
                      text: s.logOut,
                      textStyle: AppTextStyles.bold14
                          .copyWith(color: AppColors.accent),
                      onTap: () => confirmAndLogout(user),
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

  // ────────────────────────────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────────────────────────────
  Widget _tile({
    required String icon,
    required String text,
    TextStyle? textStyle,
    VoidCallback? onTap,
  }) =>
      ListTile(
        leading: SvgPicture.asset(icon, height: 24, width: 24),
        title: Text(text, style: textStyle),
        onTap: onTap,
      );

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(),
      );
}

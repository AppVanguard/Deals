import 'package:deals/features/faq/presentation/views/faq_view.dart';
import 'package:deals/features/privacy_and_policy/presentation/views/privacy_and_policy_view.dart';
import 'package:deals/features/terms_and_conditions/presentations/views/terms_and_conditions_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/app_version_text.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/generated/l10n.dart';

import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/home/presentation/manager/cubits/menu_cubit/menu_cubit.dart';

import 'logout_confirmation_dialog.dart'; // <- dialog (uses the design spec)

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    super.key,
    required this.userData,
  });

  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final Size size = MediaQuery.of(context).size;

    /// opens the confirm dialog and, if approved, fires the cubit
    Future<void> confirmAndLogout() async {
      final bool? approved = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => LogoutConfirmationDialog(s: s),
      );
      if (approved == true) {
        if (!context.mounted) return;
        context.read<MenuCubit>().logout(
              firebaseUid: userData.uId,
              authToken: userData.token,
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
          backgroundColor: Colors.white,
          child: Column(
            children: [
              _buildDrawerHeader(context),

              /* BODY ─────────────────────────────────────────── */
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesEarning,
                        text: s.earnings,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesPersonalData,
                        text: s.personalData,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesTermsConditions,
                        text: s.termsAndConditions,
                        onTap: () {
                          context.pushNamed(TermsAndConditionsView.routeName);
                        },
                      ),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesPrivacyIcon,
                        text: s.privacyPolicy,
                        onTap: () {
                          context.pushNamed(PrivacyAndPolicyView.routeName);
                        },
                      ),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesSettings,
                        text: s.settings,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesHelp,
                        text: s.help,
                        onTap: () {
                          context.pushNamed(FAQView.routeName);
                        },
                      ),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesContact,
                        text: s.contactUs,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              /* FOOTER ───────────────────────────────────────── */
              BlocListener<MenuCubit, MenuState>(
                listener: (context, state) {
                  if (state is MenuLogoutFailure) {
                    customErrorTopSnackBar(
                      context: context,
                      message: state.message,
                    );
                  }
                  if (state is MenuLogoutSuccess) {
                    context.goNamed(SigninView.routeName);
                  }
                },
                child: _buildDrawerTile(
                  iconPath: AppImages.assetsImagesLogOut,
                  text: s.logOut,
                  textStyle:
                      AppTextStyles.bold14.copyWith(color: AppColors.accent),
                  onTap: confirmAndLogout,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: AppVersionText(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ───────────── helpers ───────────── */

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      color: AppColors.darkPrimary,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userData.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          Text(
            userData.email,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required String iconPath,
    required String text,
    TextStyle? textStyle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: SizedBox(
        height: 24,
        width: 24,
        child: SvgPicture.asset(iconPath),
      ),
      title: Text(text, style: textStyle),
      onTap: onTap,
    );
  }

  Widget _buildDivider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(),
      );
}

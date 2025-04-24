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
                        iconPath: 'assets/images/earning.svg',
                        text: s.earnings,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: 'assets/images/personal_data.svg',
                        text: s.personalData,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildDrawerTile(
                        iconPath: 'assets/images/terms_conditions.svg',
                        text: s.termsAndConditions,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: 'assets/images/privacy_icon.svg',
                        text: s.privacyPolicy,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: 'assets/images/settings.svg',
                        text: s.settings,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildDrawerTile(
                        iconPath: 'assets/images/help.svg',
                        text: s.help,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: 'assets/images/contact.svg',
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

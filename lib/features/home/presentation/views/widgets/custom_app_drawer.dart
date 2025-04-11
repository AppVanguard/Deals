// lib/features/home/presentation/views/widgets/custom_app_drawer.dart

import 'package:deals/core/service/get_it_service.dart'; // for the getIt usage if needed
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/home/presentation/manager/cubits/menu_cubit/menu_cubit.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/app_version_text.dart';
import 'package:deals/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key, required this.userData});
  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: screenHeight * 0.80,
        width: screenWidth * 0.80,
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
              // 1) Header
              _buildDrawerHeader(context),

              // 2) Body (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
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

              // 3) Footer (Logout + version)
              BlocListener<MenuCubit, MenuState>(
                listener: (context, state) {
                  if (state is MenuLogoutFailure) {
                    customErrorTopSnackBar(
                        context: context, message: state.message);
                  }
                  if (state is MenuLogoutSuccess) {
                    // user is now logged out => go to sign-in
                    context.goNamed(SigninView.routeName);
                  }
                },
                child: _buildDrawerTile(
                  iconPath: AppImages.assetsImagesLogOut,
                  text: s.logOut,
                  textStyle:
                      AppTextStyles.bold14.copyWith(color: AppColors.accent),
                  onTap: () {
                    context.read<MenuCubit>().logout(
                          firebaseUid: userData.uId,
                          authToken: userData.token,
                        );
                  },
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

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      color: AppColors.darkPrimary,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        spacing: 4,
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

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(),
    );
  }
}

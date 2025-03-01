import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/app_version_text.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/home/presentation/manager/cubits/menu_cubit/menu_cubit.dart';
import 'package:deals/generated/l10n.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key, required this.userData});
  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); // For localized strings
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        // Drawer takes 80% width & 80% height
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

              // 2) Body (Scrollable list of ListTiles)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10, // vertical spacing between children
                    children: [
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesIconsEarning,
                        text: s.earnings,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesIconsPersonalData,
                        text: s.personalData,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesIconsTermsConditions,
                        text: s.termsAndConditions,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesIconsPrivacy,
                        text: s.privacyPolicy,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesIconsSettings,
                        text: s.settings,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesIconsHelp,
                        text: s.help,
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        iconPath: AppImages.assetsImagesIconsContact,
                        text: s.contactUs,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              // 3) Footer (Log Out + App Version)
              BlocListener<MenuCubit, MenuState>(
                listener: (context, state) {
                  if (state is MenuLogoutFailure) {
                    customErrorTopSnackBar(
                        context: context, message: state.message);
                  }
                  if (state is MenuLogoutSuccess) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SigninView.routeName, (route) => false);
                  }
                },
                child: _buildDrawerTile(
                  iconPath: AppImages.assetsImagesIconsLogOut,
                  text: s.logOut,
                  textStyle:
                      AppTextStyles.bold14.copyWith(color: AppColors.accent),
                  onTap: () {
                    context.read<MenuCubit>().logout(firebaseUid: userData.uId);
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: AppVersionText(), // dynamically shows the app version
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the green header portion of the drawer
  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      color: AppColors.darkPrimary,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        spacing: 4, // Space between name & email
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

  /// Reusable ListTile builder for drawer items
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

  /// Thin divider with horizontal padding
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(),
    );
  }
}

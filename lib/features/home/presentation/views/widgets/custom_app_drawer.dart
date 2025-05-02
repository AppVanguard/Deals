// lib/features/common/widgets/custom_app_drawer.dart

import 'dart:convert';

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
  Future<UserEntity?> _loadCurrentUser() async {
    final jsonString = await SecureStorageService.getUserEntity();
    if (jsonString == null) return null;
    return UserEntity.fromJson(jsonString);
  }

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
            future: _loadCurrentUser(),
            builder: (ctx, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final user = snap.data;
              if (user == null) {
                // no user in storage → force sign-in
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(SigninView.routeName);
                });
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  // HEADER
                  Container(
                    color: AppColors.darkPrimary,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 16),
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

                  // BODY
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTile(
                            icon: AppImages.assetsImagesEarning,
                            text: s.earnings,
                            onTap: () {},
                          ),
                          _buildTile(
                            icon: AppImages.assetsImagesPersonalData,
                            text: s.personalData,
                            onTap: () => context.pushNamed(
                              PersonalDataView.routeName,
                              extra: userData.uId,
                            ),
                          ),
                          _divider(),
                          _buildTile(
                            icon: AppImages.assetsImagesTermsConditions,
                            text: s.termsAndConditions,
                            onTap: () => context.pushNamed(
                              TermsAndConditionsView.routeName,
                            ),
                          ),
                          _buildTile(
                            icon: AppImages.assetsImagesPrivacyIcon,
                            text: s.privacyPolicy,
                            onTap: () => context.pushNamed(
                              PrivacyAndPolicyView.routeName,
                            ),
                          ),
                          _buildTile(
                            icon: AppImages.assetsImagesSettings,
                            text: s.settings,
                            onTap: () {},
                          ),
                          _divider(),
                          _buildTile(
                            icon: AppImages.assetsImagesHelp,
                            text: s.help,
                            onTap: () => context.pushNamed(
                              FAQView.routeName,
                            ),
                          ),
                          _buildTile(
                            icon: AppImages.assetsImagesContact,
                            text: s.contactUs,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  // FOOTER
                  BlocListener<MenuCubit, MenuState>(
                    listener: (ctx, state) {
                      if (state is MenuLogoutFailure) {
                        customErrorTopSnackBar(
                          context: ctx,
                          message: state.message,
                        );
                      } else if (state is MenuLogoutSuccess) {
                        context.goNamed(SigninView.routeName);
                      }
                    },
                    child: _buildTile(
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

  Widget _buildTile({
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

import 'dart:async';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/personal_data/data/repos/presonal_data_repo_impl.dart';
import 'package:deals/features/personal_data/presentation/manager/personal_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:deals/generated/l10n.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/widgets/error_banner.dart';

import 'package:deals/features/personal_data/presentation/views/widgets/personal_data_view_body.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key, required this.id});
  static const String routeName = '/personal-data';
  final String id;

  // Placeholder for skeleton mode
  static final _placeholderUser = UserEntity(
    id: '',
    token: '',
    uId: '',
    fullName: '',
    email: '',
    phone: '',
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalDataCubit>(
      create: (_) => PersonalDataCubit(
        repo: PersonalDataRepoImpl(userService: getIt()),
        userId: id,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).PersonalData),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.text,
        ),
        body: BlocConsumer<PersonalDataCubit, PersonalDataState>(
          listener: (ctx, state) async {
            final messenger = ScaffoldMessenger.of(ctx);

            if (state is PersonalDataUpdateSuccess) {
              // 1) Persist updated user
              await SecureStorageService.saveUserEntity(
                state.user,
              );

              // 2) Remove any existing banner
              messenger.hideCurrentMaterialBanner();
              if (!context.mounted) return;
              // 3) Show custom‐shaped banner
              messenger.showMaterialBanner(
                MaterialBanner(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  content: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    clipBehavior: Clip.antiAlias,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFEAFFF1),
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
                        SvgPicture.asset(AppImages.assetsImagesSuccess),
                        const SizedBox(height: 12),
                        Text(
                          S.of(ctx).DataSaved,
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
                  // Must provide at least one action
                  actions: const [
                    SizedBox.shrink(),
                  ],
                ),
              );

              // 4) Auto‐dismiss after 2 seconds
              Timer(const Duration(seconds: 2), () {
                messenger.hideCurrentMaterialBanner();
              });
            }

            if (state is PersonalDataUpdateFailure) {
              // Remove any banner
              messenger.hideCurrentMaterialBanner();
              // Show error snackbar
              messenger.showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (ctx, state) {
            // Show skeleton while loading initial data
            if (state is PersonalDataInitial ||
                state is PersonalDataLoadInProgress) {
              return Skeletonizer(
                child: PersonalDataViewBody(user: _placeholderUser),
              );
            }

            // Show load error
            if (state is PersonalDataLoadFailure) {
              return Center(child: ErrorBanner(message: state.message));
            }

            // On load success or after update success, show form
            final user = state is PersonalDataLoadSuccess
                ? state.user
                : state is PersonalDataUpdateSuccess
                    ? state.user
                    : _placeholderUser;

            return Skeletonizer(
              enabled: false,
              child: PersonalDataViewBody(user: user),
            );
          },
        ),
      ),
    );
  }
}

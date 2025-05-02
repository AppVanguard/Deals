// lib/features/profile/presentation/views/personal_data_view.dart

import 'dart:developer';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/personal_data/data/repos/presonal_data_repo_impl.dart';
import 'package:deals/features/personal_data/presentation/manager/personal_data_cubit.dart';
import 'package:deals/features/personal_data/presentation/views/widgets/personal_data_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:deals/generated/l10n.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/secure_storage_service.dart';

import 'package:deals/core/entities/user_entity.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key, required this.id});
  static const String routeName = '/personal-data';
  final String id;

  // placeholder entity so the skeleton can render
  static final _placeholderUser = UserEntity(
    id: '',
    token: '',
    uId: '',
    fullName: '',
    email: '',
    phone: '',
    profileImageUrl: null,
    dateOfBirth: null,
    gender: null,
    country: null,
    city: null,
    totalSavings: 0,
    favoriteStores: const [],
    bookmarks: const [],
    isActive: null,
    createdAt: null,
    updatedAt: null,
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
        ),
        body: BlocConsumer<PersonalDataCubit, PersonalDataState>(
          listener: (ctx, state) async {
            if (state is PersonalDataUpdateSuccess) {
              // Persist the updated entity
              await SecureStorageService.saveUserEntity(
                state.user.toJson(),
              );
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(S.of(ctx).SaveSuccess),
                  backgroundColor: AppColors.primary,
                ),
              );
            } else if (state is PersonalDataUpdateFailure) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (ctx, state) {
            // On initial or load‐in‐progress, show skeleton
            final isLoading = state is PersonalDataInitial ||
                state is PersonalDataLoadInProgress;
            if (state is PersonalDataLoadFailure) {
              // show a load error
              return Center(child: Text(state.message));
            }

            // Pick the entity for the form (loaded or placeholder)
            final user = state is PersonalDataLoadSuccess
                ? state.user
                : state is PersonalDataUpdateSuccess
                    ? state.user
                    : _placeholderUser;

            return Skeletonizer(
              enabled: isLoading,
              child: PersonalDataViewBody(user: user),
            );
          },
        ),
      ),
    );
  }
}

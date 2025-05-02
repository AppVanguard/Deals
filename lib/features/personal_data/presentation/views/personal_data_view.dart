import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/features/personal_data/data/repos/presonal_data_repo_impl.dart';
import 'package:deals/features/personal_data/presentation/manager/personal_data_cubit.dart';
import 'package:deals/features/personal_data/presentation/views/widgets/personal_data_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/generated/l10n.dart';

import 'package:deals/core/service/get_it_service.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key, required this.id});

  static const String routeName = '/personal-data';
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalDataCubit>(
      create: (_) => PersonalDataCubit(
        repo: PersonalDataRepoImpl(userService: getIt()),
        userId: id,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).PersonalData)),
        body: BlocConsumer<PersonalDataCubit, PersonalDataState>(
          listener: (context, state) {
            if (state is PersonalDataSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).SaveSuccess)),
              );
            }
          },
          builder: (context, state) {
            if (state is PersonalDataLoading || state is PersonalDataInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PersonalDataFailure) {
              return buildCustomErrorScreen(
                  context: context,
                  onRetry: () {
                    context.read<PersonalDataCubit>().load();
                  });
            } else if (state is PersonalDataSuccess) {
              return PersonalDataViewBody(user: state.user);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

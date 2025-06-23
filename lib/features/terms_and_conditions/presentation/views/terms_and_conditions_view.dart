import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/terms_and_conditions/presentation/manager/cubits/terms_cubit/terms_cubit.dart';
import 'package:deals/features/terms_and_conditions/data/terms_repo_impl.dart';
import 'package:deals/features/terms_and_conditions/presentation/views/widgets/terms_and_conditions_view_body.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/terms_and_conditions/presentations/manager/cubits/terms_cubit/terms_cubit.dart';
import 'package:deals/features/terms_and_conditions/data/terms_and_conditions_repository.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});
  static const String routeName = '/termsAndConditionsView';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TermsCubit(repository: JsonTermsRepository())..loadTerms(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          title: Text(
            S.of(context).termsAndConditions,
          ),
          centerTitle: true,
        ),
        body: const TermsAndConditionsViewBody(),
      ),
    );
  }
}

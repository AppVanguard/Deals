import 'package:deals/features/terms_and_conditions/data/repo/terms_repo_impl.dart';
import 'package:deals/features/terms_and_conditions/presentation/manager/cubits/terms_cubit/terms_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/l10n.dart';

import 'widgets/terms_and_conditions_view_body.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});
  static const String routeName = '/termsAndConditionsView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TermsCubit(
        repository: const JsonTermsRepository(),
      )..loadTerms(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          title: Text(S.of(context).termsAndConditions),
          centerTitle: true,
        ),
        body: const TermsAndConditionsViewBody(),
      ),
    );
  }
}

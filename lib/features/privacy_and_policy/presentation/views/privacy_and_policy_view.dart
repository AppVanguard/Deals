import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/privacy_and_policy/presentation/views/widgets/privacy_and_policy_view_body.dart';
import 'package:deals/features/privacy_and_policy/presentation/manager/cubits/privacy_policy_cubit/privacy_policy_cubit.dart';
import 'package:deals/features/privacy_and_policy/data/privacy_policy_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

class PrivacyAndPolicyView extends StatelessWidget {
  const PrivacyAndPolicyView({super.key});
  static const String routeName = '/privacyAndPolicyView';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PrivacyPolicyCubit(repository: JsonPrivacyRepository())..loadPolicy(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          title: Text(S.of(context).PrivacyAndPolicy),
          centerTitle: true,
        ),
        body: const PrivacyAndPolicyViewBody(),
      ),
    );
  }
}

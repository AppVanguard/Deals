import 'package:deals/features/privacy_and_policy/presentation/manager/cubits/privacy_policy_cubit/privacy_policy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../data/json_privacy_policy_repository.dart';
import 'widgets/privacy_and_policy_view_body.dart';

class PrivacyAndPolicyView extends StatelessWidget {
  const PrivacyAndPolicyView({super.key});
  static const String routeName = '/privacyAndPolicyView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrivacyPolicyCubit(
        repository: const JsonPrivacyPolicyRepository(),
      )..loadPolicy(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          title: Text(S.of(context).privacyPolicy),
          centerTitle: true,
        ),
        body: const PrivacyAndPolicyViewBody(),
      ),
    );
  }
}

import 'package:deals/features/faq/presentation/manager/cubits/faq_cubit/faq_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../data/json_faq_repository.dart';
import 'widgets/faq_view_body.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});
  static const String routeName = '/faq';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FaqCubit(repository: const JsonFaqRepository())..loadFaq(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          title: Text(S.of(context).FAQ),
          centerTitle: true,
        ),
        body: const FaqViewBody(),
      ),
    );
  }
}

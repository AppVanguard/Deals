import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/faq/domain/faq_repository.dart';
import 'package:deals/features/faq/presentation/manager/cubits/faq_cubit/faq_cubit.dart';
import 'package:deals/features/faq/presentation/views/widgets/faq_view_body.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FAQView extends StatelessWidget {
  const FAQView({super.key, required this.repository});

  static const String routeName = '/faq';

  /// Repository used to load FAQ data.
  final FaqRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FaqCubit(repository: repository)..loadFaqs(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).Help),
          elevation: 0,
          backgroundColor: AppColors.background,
          centerTitle: true,
        ),
        body: const FAQViewBody(),
      ),
    );
  }
}

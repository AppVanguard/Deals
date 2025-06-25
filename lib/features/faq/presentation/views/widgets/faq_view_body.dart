import 'package:deals/core/widgets/error_message_card.dart';
import 'package:deals/features/faq/presentation/manager/cubits/faq_cubit/faq_cubit.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'faq_card.dart';

class FaqViewBody extends StatelessWidget {
  const FaqViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqCubit, FaqState>(
      builder: (context, state) {
        if (state is FaqLoading || state is FaqInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FaqFailure) {
          return Center(
            child: ErrorMessageCard(
              title: S.of(context).FailToLoadFAQ,
              message: S.of(context).CheckConnectionError,
              onRetry: () => context.read<FaqCubit>().loadFaq(),
            ),
          );
        } else if (state is FaqSuccess) {
          final sections = state.document.sections;

          return Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var sec in sections) ...[
                    FaqCard(
                      question: sec.title,
                      answer: sec.bullets, // your answers array
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

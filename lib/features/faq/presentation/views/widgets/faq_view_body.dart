import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deals/core/widgets/error_message_card.dart';
import 'package:deals/features/faq/presentation/manager/cubits/faq_cubit/faq_cubit.dart';
import 'faq_card.dart';

class FAQViewBody extends StatelessWidget {
  const FAQViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqCubit, FaqState>(
      builder: (context, state) {
        if (state is FaqLoading || state is FaqInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FaqFailure) {
          return Center(
            child: ErrorMessageCard(
              title: 'Failed to load FAQs',
              message: 'Please check your connection and try again.',
              onRetry: () => context.read<FaqCubit>().loadFaqs(),
            ),
          );
        } else if (state is FaqSuccess) {
          final faqs = state.faqs;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: faqs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final item = faqs[i];
              return FaqCard(
                question: item.question,
                answer: item.answer,
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

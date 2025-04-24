import 'package:flutter/material.dart';
import 'package:deals/features/faq/data/faq_item.dart';
import 'package:deals/features/faq/domain/faq_repository.dart';
import 'faq_card.dart';

class FAQViewBody extends StatefulWidget {
  const FAQViewBody({super.key});

  @override
  State<FAQViewBody> createState() => _FAQViewBodyState();
}

class _FAQViewBodyState extends State<FAQViewBody> {
  late final Future<List<FAQItem>> _faqsFuture;

  @override
  void initState() {
    super.initState();
    _faqsFuture = JsonFaqRepository().loadFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FAQItem>>(
      future: _faqsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final faqs = snapshot.data ?? [];
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
      },
    );
  }
}

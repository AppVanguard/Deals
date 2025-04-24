import 'package:deals/core/widgets/collapsible_card.dart';
import 'package:flutter/material.dart';

class FaqCard extends StatelessWidget {
  final String question;
  final List<String> answer;
  final bool initiallyExpanded;

  const FaqCard({
    super.key,
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
      initiallyExpanded: initiallyExpanded,
      title: Text(
        question,
        style: const TextStyle(
          color: Color(0xFF04832D),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.5,
          fontFamily: 'Roboto',
        ),
      ),
      children: answer.map((line) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•  ', style: TextStyle(fontSize: 14, height: 1.5)),
              Expanded(
                child: Text(
                  line,
                  style: const TextStyle(
                    color: Color(0xFF1D241F),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

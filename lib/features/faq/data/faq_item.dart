class FAQItem {
  final String question;
  final List<String> answer;

  FAQItem({required this.question, required this.answer});
  factory FAQItem.fromJson(Map<String, dynamic> json) => FAQItem(
        question: json['question'] as String,
        answer: List<String>.from(json['answer'] as List),
      );
}

import 'package:deals/features/faq/presentation/views/widgets/faq_view_body.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

class FAQView extends StatelessWidget {
  const FAQView({super.key});
  static const String routeName = '/faq';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).Help,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: const FAQViewBody(),
    );
  }
}

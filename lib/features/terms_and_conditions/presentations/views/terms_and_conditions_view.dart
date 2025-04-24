import 'package:deals/features/terms_and_conditions/presentations/views/widgets/terms_and_conditions_view_body.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});
  static const String routeName = '/termsAndConditionsView';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          S.of(context).termsAndConditions,
        ),
        centerTitle: true,
      ),
      body: const TermsAndConditionsViewBody(),
    );
  }
}

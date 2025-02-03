import 'package:flutter/material.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/personal_data_view_body.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key});
  static const routeName = 'personal_data_view';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: PersonalDataViewBody(),
    );
  }
}

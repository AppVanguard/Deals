import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});
  static const routeName = '/notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          S.of(context).Notifications,
          style: AppTextStyles.bold24,
        ),
      ),
    );
  }
}

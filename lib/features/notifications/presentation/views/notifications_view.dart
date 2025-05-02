import 'package:deals/features/notifications/presentation/views/widgets/build_notifications_app_bar.dart';
import 'package:deals/features/notifications/presentation/views/widgets/notifications_view_body.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  final String userId;
  final String token;
  const NotificationsView({
    super.key,
    required this.userId,
    required this.token,
  });

  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildNotificationsAppBar(context),
      body: NotificationsViewBody(userId: userId, token: token),
    );
  }
}

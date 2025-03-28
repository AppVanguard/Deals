// lib/features/notifications/presentation/views/notifications_view.dart

import 'dart:developer';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/notifications/presentation/views/widgets/notifications_list_tile.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsView extends StatefulWidget {
  final String userId;
  final String token;
  const NotificationsView(
      {super.key, required this.userId, required this.token});
  static const routeName = '/notifications';

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationsCubit>();
    // When NotificationsView is opened, we don't force a fetch here since
    // MainView already loaded notifications.
    log('NotificationsView initState: using cached notifications.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(S.of(context).Notifications),
        centerTitle: true,
      ),
      body: BlocConsumer<NotificationsCubit, NotificationsState>(
        listener: (context, state) {
          if (state is NotificationsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return _buildSkeletonList();
          } else if (state is NotificationsSuccess) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return Center(
                child: Text(S.of(context).NoNotifications),
              );
            }
            return Skeletonizer(
              enabled: state.isRefreshing,
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Dismissible(
                    key: ValueKey(notif.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      context
                          .read<NotificationsCubit>()
                          .removeNotification(notif.id);
                    },
                    child: NotificationTile(
                      key: ValueKey(notif.id),
                      notification: notif,
                      onTap: () {
                        if (!notif.read && notif.id.isNotEmpty) {
                          context
                              .read<NotificationsCubit>()
                              .markNotificationAsRead(notif.id, widget.token);
                        }
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is NotificationsFailure) {
            return Center(child: Text(state.error));
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

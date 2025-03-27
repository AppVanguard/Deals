import 'dart:developer';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/notifications/presentation/views/widgets/notifications_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsView extends StatefulWidget {
  final String userId;
  final String token;
  const NotificationsView({Key? key, required this.userId, required this.token})
      : super(key: key);
  static const routeName = '/notifications';

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationsCubit>();
    if (cubit.state is NotificationsInitial) {
      cubit.fetchNotifications(widget.token);
      log('Fetching notifications for the first time.');
    } else {
      log('Using cached notifications.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
              return const Center(child: Text('No notifications.'));
            }
            return Skeletonizer(
              enabled: state.isRefreshing,
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Dismissible(
                    key: ValueKey(notif.id),
                    direction: DismissDirection.horizontal,
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
            return buildCustomErrorScreen(
              context: context,
              onRetry: () {
                context
                    .read<NotificationsCubit>()
                    .fetchNotifications(widget.token);
              },
            );
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

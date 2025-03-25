import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsView extends StatelessWidget {
  final String userId;
  const NotificationsView({super.key, required this.userId});
  static const routeName = '/notifications';

  String _timeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationsFailure) {
            return buildCustomErrorScreen(
                context: context,
                onRetry: () {
                  context.read<NotificationsCubit>().fetchNotifications();
                });
          } else if (state is NotificationsSuccess) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications.'));
            }
            return ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final isRead = notif.read ?? false;
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor:
                        isRead ? Colors.grey[300] : Colors.green[100],
                    child: Icon(
                      Icons.notifications,
                      color: isRead ? Colors.grey : Colors.green,
                    ),
                  ),
                  title: Text(notif.title ?? 'No Title'),
                  subtitle: Text(
                    notif.body ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    _timeAgo(notif.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  tileColor: isRead ? Colors.white : Colors.green[50],
                  onTap: () {
                    if (!(notif.read ?? false) && notif.id != null) {
                      context
                          .read<NotificationsCubit>()
                          .markNotificationAsRead(notif.id!);
                    }
                  },
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

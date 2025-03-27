import 'dart:developer';
import 'package:deals/features/notifications/presentation/views/widgets/notifications_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';

class NotificationsView extends StatefulWidget {
  final String userId;
  final String token;
  static const routeName = '/notifications';

  const NotificationsView({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationsCubit>();
    // If the cubit's state is initial, fetch once.
    if (cubit.state is NotificationsInitial) {
      log('NotificationsCubit is initial -> fetch from server/local DB');
      cubit.fetchNotifications(widget.token);
    } else {
      log('NotificationsCubit already has data -> no fetch needed');
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
            return ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return NotificationListTile(
                  notif: notif,
                  isRefreshing: state.isRefreshing,
                  onTap: () {
                    if (!(notif.read ?? false) && notif.id != null) {
                      context
                          .read<NotificationsCubit>()
                          .markNotificationAsRead(notif.id!, widget.token);
                    }
                  },
                );
              },
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
          // If it's initial but we haven't done anything yet, show a placeholder.
          return _buildSkeletonList();
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

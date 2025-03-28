import 'dart:developer';
import 'package:deals/features/notifications/presentation/views/widgets/notifications_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/notifications/domain/entities/notification_entity.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

// The skeleton shape method from above
Widget buildNotificationSkeletonItem() {
  return Skeletonizer(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 150, height: 12, color: Colors.grey),
                const SizedBox(height: 8),
                Container(width: 100, height: 10, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 40, height: 10, color: Colors.grey),
        ],
      ),
    ),
  );
}

class NotificationsView extends StatefulWidget {
  final String userId;
  final String token;
  const NotificationsView({
    super.key,
    required this.userId,
    required this.token,
  });

  static const routeName = '/notifications';

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Optionally do an initial fetch
    // context.read<NotificationsCubit>().fetchNotifications(widget.token, reset: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<NotificationsCubit>();
    final currentState = cubit.state;
    if (currentState is NotificationsSuccess &&
        !currentState.isLoadingMore &&
        currentState.hasMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      log("Scrolling near bottom => load more notifications...");
      cubit.loadMoreNotifications();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Notifications),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          if (state is NotificationsLoading || state is NotificationsInitial) {
            // Show top-level skeleton placeholders for the entire screen
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => buildNotificationSkeletonItem(),
            );
          } else if (state is NotificationsFailure) {
            return buildCustomErrorScreen(
              context: context,
              onRetry: () {
                context
                    .read<NotificationsCubit>()
                    .fetchNotifications(widget.token, reset: true);
              },
            );
          } else if (state is NotificationsSuccess) {
            final notifications = state.notifications;
            final newLoadCount = state.newLoadCount;

            if (notifications.isEmpty && newLoadCount == 0) {
              return Center(child: Text(S.of(context).NoNotifications));
            }

            final itemCount = notifications.length + newLoadCount;

            return ListView.builder(
              controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // If it's a real notification
                if (index < notifications.length) {
                  final notif = notifications[index];
                  return _buildNotificationCard(
                    isSkeleton: false,
                    notification: notif,
                    onTap: () {
                      if (!notif.read) {
                        context
                            .read<NotificationsCubit>()
                            .markNotificationAsRead(notif.id, widget.token);
                      }
                    },
                  );
                } else {
                  // The last newLoadCount items => skeleton placeholders
                  return _buildNotificationCard(
                    isSkeleton: true,
                    notification: null,
                    onTap: null,
                  );
                }
              },
            );
          }
          // fallback
          return const SizedBox();
        },
      ),
    );
  }

  // Our single method that decides skeleton vs. real:
  Widget _buildNotificationCard({
    required bool isSkeleton,
    required NotificationEntity? notification,
    required VoidCallback? onTap,
  }) {
    if (isSkeleton || notification == null) {
      return buildNotificationSkeletonItem();
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: NotificationTile(
          notification: notification,
          onTap: onTap ?? () {},
        ),
      );
    }
  }
}

import 'package:deals/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/features/notifications/domain/entities/notification_entity.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/notifications/presentation/views/widgets/notification_tile.dart';
import 'package:deals/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsViewBody extends StatefulWidget {
  final String userId;
  final String token;
  const NotificationsViewBody(
      {super.key, required this.userId, required this.token});

  @override
  State<NotificationsViewBody> createState() => _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<NotificationsViewBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Optionally, if you want to fetch initially here:
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
      appLog("Scrolling near bottom => load more notifications...");
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
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoading || state is NotificationsInitial) {
          // Show full skeleton list while loading
          return ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) => buildNotificationSkeletonItem(),
          );
        } else if (state is NotificationsFailure) {
          if (state.error.contains('Invalid token')) {
            return const SizedBox.shrink();
          }
          return buildCustomErrorScreen(
            context: context,
            onRetry: () => context
                .read<NotificationsCubit>()
                .fetchNotifications(widget.token, reset: true),
            errorMessage: state.error,
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
                // Skeleton placeholder for new items
                return _buildNotificationCard(
                  isSkeleton: true,
                  notification: null,
                  onTap: null,
                );
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }

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

Widget buildNotificationSkeletonItem() {
  return Skeletonizer(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Circle placeholder for avatar
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // Column with two placeholder lines
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
          // Placeholder for trailing text (time)
          Container(width: 40, height: 10, color: Colors.grey),
        ],
      ),
    ),
  );
}

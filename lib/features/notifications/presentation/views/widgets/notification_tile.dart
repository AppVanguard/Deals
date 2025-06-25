import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Tile showing a notification title, body and timestamp.
class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            notification.read ? AppColors.lightGray : AppColors.lightPrimary,
        child: ClipOval(
          child: (notification.image != null && notification.image!.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: notification.image!,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                  placeholder: (context, url) {
                    return const CircularProgressIndicator(
                      color: Colors.green,
                    );
                  },
                )
              : const Icon(Icons.notifications, color: Colors.green),
        ),
      ),
      title: Text(notification.title),
      subtitle: Text(
        notification.body,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _timeAgo(notification.createdAt),
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      tileColor: notification.read ? Colors.white : Colors.green[50],
      onTap: onTap,
    );
  }
}

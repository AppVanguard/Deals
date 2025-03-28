import 'package:deals/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            notification.read ? Colors.grey[300] : Colors.green[100],
        child: ClipOval(
          child: (notification.image != null && notification.image!.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: notification.image!,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
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

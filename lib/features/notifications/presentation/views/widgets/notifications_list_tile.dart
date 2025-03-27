import 'package:deals/features/notifications/data/models/notification.dart'
    as Remote;
import 'package:flutter/material.dart';

class NotificationListTile extends StatelessWidget {
  final Remote.Notification notif;

  /// When isRefreshing is true, overlay a subtle skeleton effect.
  final bool isRefreshing;
  final VoidCallback onTap;

  const NotificationListTile({
    super.key,
    required this.notif,
    required this.isRefreshing,
    required this.onTap,
  });

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
    return Stack(
      children: [
        ListTile(
          key: ValueKey(notif.id),
          leading: CircleAvatar(
            backgroundColor:
                (notif.read ?? false) ? Colors.grey[300] : Colors.green[100],
            child: Icon(
              Icons.notifications,
              color: (notif.read ?? false) ? Colors.grey : Colors.green,
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
          tileColor: (notif.read ?? false) ? Colors.white : Colors.green[50],
          onTap: onTap,
        ),
        if (isRefreshing)
          Positioned.fill(
            child: Container(
              color: Colors.grey.withValues(alpha: .3),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

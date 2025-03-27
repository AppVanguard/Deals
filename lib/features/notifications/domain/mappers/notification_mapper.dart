import 'package:deals/features/notifications/data/models/notification.dart';
import 'package:deals/features/notifications/domain/entities/notification_entity.dart';

class NotificationMapper {
  static NotificationEntity mapToEntity(Notification model) {
    return NotificationEntity(
      id: model.id ?? '',
      userId: model.userId ?? '',
      title: model.title ?? '',
      body: model.body ?? '',
      read: model.read ?? false,
      createdAt: model.createdAt ?? DateTime.now(),
    );
  }

  static List<NotificationEntity> mapToEntities(List<Notification> models) {
    return models.map((model) => mapToEntity(model)).toList();
  }
}

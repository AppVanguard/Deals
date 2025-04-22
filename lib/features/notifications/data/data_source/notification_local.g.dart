// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationLocalAdapter extends TypeAdapter<NotificationLocal> {
  @override
  final int typeId = 0;

  @override
  NotificationLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationLocal(
      notificationId: fields[0] as String,
      userId: fields[1] as String,
      read: fields[2] as bool,
      createdAt: fields[3] as DateTime,
      rawJson: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationLocal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.notificationId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.read)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.rawJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

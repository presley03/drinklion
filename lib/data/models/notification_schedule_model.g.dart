// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationScheduleModel _$NotificationScheduleModelFromJson(
  Map<String, dynamic> json,
) => NotificationScheduleModel(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  type: json['type'] as String,
  mealType: json['mealType'] as String?,
  time: json['time'] as String,
  isEnabled: json['isEnabled'] as bool? ?? true,
  isFastingMode: json['isFastingMode'] as bool? ?? false,
  title: json['title'] as String?,
  body: json['body'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$NotificationScheduleModelToJson(
  NotificationScheduleModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'type': instance.type,
  'mealType': instance.mealType,
  'time': instance.time,
  'isEnabled': instance.isEnabled,
  'isFastingMode': instance.isFastingMode,
  'title': instance.title,
  'body': instance.body,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

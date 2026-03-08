// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderLogModel _$ReminderLogModelFromJson(Map<String, dynamic> json) =>
    ReminderLogModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      reminderType: json['reminderType'] as String,
      mealType: json['mealType'] as String?,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      quantity: json['quantity'] as String?,
      skippedReason: json['skippedReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ReminderLogModelToJson(ReminderLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'reminderType': instance.reminderType,
      'mealType': instance.mealType,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'quantity': instance.quantity,
      'skippedReason': instance.skippedReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

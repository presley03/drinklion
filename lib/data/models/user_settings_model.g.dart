// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    UserSettingsModel(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      notificationSound: json['notificationSound'] as bool? ?? true,
      vibration: json['vibration'] as bool? ?? true,
      theme: json['theme'] as String? ?? 'light',
      language: json['language'] as String? ?? 'id',
      fontSize: json['fontSize'] as String? ?? 'normal',
      quietHoursStart: json['quietHoursStart'] as String?,
      quietHoursEnd: json['quietHoursEnd'] as String?,
      fastingModeEnabled: json['fastingModeEnabled'] as bool? ?? false,
      fastingStartTime: json['fastingStartTime'] as String?,
      fastingEndTime: json['fastingEndTime'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserSettingsModelToJson(UserSettingsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'notificationSound': instance.notificationSound,
      'vibration': instance.vibration,
      'theme': instance.theme,
      'language': instance.language,
      'fontSize': instance.fontSize,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
      'fastingModeEnabled': instance.fastingModeEnabled,
      'fastingStartTime': instance.fastingStartTime,
      'fastingEndTime': instance.fastingEndTime,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

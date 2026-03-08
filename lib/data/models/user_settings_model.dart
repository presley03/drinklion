import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:drinklion/domain/entities/entities.dart';

part 'user_settings_model.g.dart';

@JsonSerializable()
class UserSettingsModel {
  final String? id;
  final String userId;
  final bool notificationSound;
  final bool vibration;
  final String theme;
  final String language;
  final String fontSize;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final bool fastingModeEnabled;
  final String? fastingStartTime;
  final String? fastingEndTime;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserSettingsModel({
    this.id,
    required this.userId,
    this.notificationSound = true,
    this.vibration = true,
    this.theme = 'light',
    this.language = 'id',
    this.fontSize = 'normal',
    this.quietHoursStart,
    this.quietHoursEnd,
    this.fastingModeEnabled = false,
    this.fastingStartTime,
    this.fastingEndTime,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert JSON to UserSettingsModel
  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  /// Convert UserSettingsModel to JSON
  Map<String, dynamic> toJson() => _$UserSettingsModelToJson(this);

  /// Create copy with modifications
  UserSettingsModel copyWith({
    String? id,
    String? userId,
    bool? notificationSound,
    bool? vibration,
    String? theme,
    String? language,
    String? fontSize,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? fastingModeEnabled,
    String? fastingStartTime,
    String? fastingEndTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettingsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationSound: notificationSound ?? this.notificationSound,
      vibration: vibration ?? this.vibration,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      fontSize: fontSize ?? this.fontSize,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      fastingModeEnabled: fastingModeEnabled ?? this.fastingModeEnabled,
      fastingStartTime: fastingStartTime ?? this.fastingStartTime,
      fastingEndTime: fastingEndTime ?? this.fastingEndTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Parse quiet hours time string (HH:mm) to TimeOfDay
  TimeOfDay? parseQuietHoursStart() {
    if (quietHoursStart == null) return null;
    final parts = quietHoursStart!.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Parse quiet hours end time string (HH:mm) to TimeOfDay
  TimeOfDay? parseQuietHoursEnd() {
    if (quietHoursEnd == null) return null;
    final parts = quietHoursEnd!.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Parse fasting start time string (HH:mm) to TimeOfDay
  TimeOfDay? parseFastingStartTime() {
    if (fastingStartTime == null) return null;
    final parts = fastingStartTime!.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Parse fasting end time string (HH:mm) to TimeOfDay
  TimeOfDay? parseFastingEndTime() {
    if (fastingEndTime == null) return null;
    final parts = fastingEndTime!.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Convert UserSettingsModel to UserSettings entity
  UserSettings toEntity() {
    return UserSettings(
      id: id,
      userId: userId,
      notificationSound: notificationSound,
      vibration: vibration,
      theme: theme,
      language: language,
      fontSize: fontSize,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
      fastingModeEnabled: fastingModeEnabled,
      fastingStartTime: fastingStartTime,
      fastingEndTime: fastingEndTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create UserSettingsModel from UserSettings entity
  factory UserSettingsModel.fromEntity(UserSettings entity) {
    return UserSettingsModel(
      id: entity.id,
      userId: entity.userId ?? '',
      notificationSound: entity.notificationSound,
      vibration: entity.vibration,
      theme: entity.theme,
      language: entity.language,
      fontSize: entity.fontSize,
      quietHoursStart: entity.quietHoursStart,
      quietHoursEnd: entity.quietHoursEnd,
      fastingModeEnabled: entity.fastingModeEnabled,
      fastingStartTime: entity.fastingStartTime,
      fastingEndTime: entity.fastingEndTime,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  String toString() =>
      'UserSettingsModel(id: $id, userId: $userId, theme: $theme, language: $language, fontSize: $fontSize, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          theme == other.theme &&
          language == other.language;

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ theme.hashCode ^ language.hashCode;
}

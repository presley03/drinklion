import 'package:flutter/material.dart';
import 'package:drinklion/core/config/enums.dart';

/// User profile entity
class UserProfile {
  final String? id;
  final String gender; // male, female
  final AgeRange ageRange;
  final List<HealthCondition> healthConditions;
  final ActivityLevel activityLevel;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfile({
    this.id,
    required this.gender,
    required this.ageRange,
    this.healthConditions = const [],
    required this.activityLevel,
    required this.createdAt,
    this.updatedAt,
  });

  UserProfile copyWith({
    String? id,
    String? gender,
    AgeRange? ageRange,
    List<HealthCondition>? healthConditions,
    ActivityLevel? activityLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
      healthConditions: healthConditions ?? this.healthConditions,
      activityLevel: activityLevel ?? this.activityLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Reminder log entity (completion tracking)
class ReminderLog {
  final String? id;
  final String? userId;
  final ReminderType type; // drink, meal
  final MealType? mealType; // breakfast, lunch, dinner, snack
  final DateTime scheduledTime;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? quantity; // e.g., "1 gelas", "1 piring"
  final String? skippedReason;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReminderLog({
    this.id,
    this.userId,
    required this.type,
    this.mealType,
    required this.scheduledTime,
    this.isCompleted = false,
    this.completedAt,
    this.quantity,
    this.skippedReason,
    required this.createdAt,
    this.updatedAt,
  });

  ReminderLog copyWith({
    String? id,
    String? userId,
    ReminderType? type,
    MealType? mealType,
    DateTime? scheduledTime,
    bool? isCompleted,
    DateTime? completedAt,
    String? quantity,
    String? skippedReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      mealType: mealType ?? this.mealType,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      quantity: quantity ?? this.quantity,
      skippedReason: skippedReason ?? this.skippedReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Notification schedule entity (scheduled reminders)
class NotificationSchedule {
  final String? id;
  final String? userId;
  final ReminderType type; // drink, meal
  final MealType? mealType;
  final String time; // HH:MM format
  final bool isEnabled;
  final bool isFastingMode;
  final String? title;
  final String? body;
  final DateTime createdAt;
  final DateTime? updatedAt;

  NotificationSchedule({
    this.id,
    this.userId,
    required this.type,
    this.mealType,
    required this.time,
    this.isEnabled = true,
    this.isFastingMode = false,
    this.title,
    this.body,
    required this.createdAt,
    this.updatedAt,
  });

  NotificationSchedule copyWith({
    String? id,
    String? userId,
    ReminderType? type,
    MealType? mealType,
    String? time,
    bool? isEnabled,
    bool? isFastingMode,
    String? title,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationSchedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      mealType: mealType ?? this.mealType,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
      isFastingMode: isFastingMode ?? this.isFastingMode,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// User settings entity
class UserSettings {
  final String? id;
  final String? userId;
  final bool notificationSound;
  final bool vibration;
  final String theme; // light, dark, system
  final String language; // id, en
  final String fontSize; // normal, large, xl
  final String? quietHoursStart; // HH:MM format
  final String? quietHoursEnd; // HH:MM format
  final bool fastingModeEnabled;
  final String? fastingStartTime; // HH:MM format
  final String? fastingEndTime; // HH:MM format
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserSettings({
    this.id,
    this.userId,
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

  UserSettings copyWith({
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
    return UserSettings(
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
}

/// TimeOfDay extension for persistence
extension TimeOfDayExtension on TimeOfDay {
  String toTimeString() => '$hour:${minute.toString().padLeft(2, '0')}';

  static TimeOfDay fromTimeString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

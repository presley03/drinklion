import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/core/config/enums.dart';

part 'notification_schedule_model.g.dart';

@JsonSerializable()
class NotificationScheduleModel {
  final String? id;
  final String? userId;
  final String type;
  final String? mealType;
  final String time;
  final bool isEnabled;
  final bool isFastingMode;
  final String? title;
  final String? body;
  final DateTime createdAt;
  final DateTime? updatedAt;

  NotificationScheduleModel({
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

  /// Convert JSON to NotificationScheduleModel
  factory NotificationScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleModelFromJson(json);

  /// Convert NotificationScheduleModel to JSON
  Map<String, dynamic> toJson() => _$NotificationScheduleModelToJson(this);

  /// Create copy with modifications
  NotificationScheduleModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? mealType,
    String? time,
    bool? isEnabled,
    bool? isFastingMode,
    String? title,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationScheduleModel(
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

  /// Parse time string (HH:mm) to TimeOfDay
  TimeOfDay parseTimeOfDay() {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1].trim()),
    );
  }

  /// Convert NotificationScheduleModel to NotificationSchedule entity
  NotificationSchedule toEntity() {
    return NotificationSchedule(
      id: id,
      userId: userId,
      type: _parseReminderType(type),
      mealType: mealType != null ? _parseMealType(mealType!) : null,
      time: time,
      isEnabled: isEnabled,
      isFastingMode: isFastingMode,
      title: title,
      body: body,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create NotificationScheduleModel from NotificationSchedule entity
  factory NotificationScheduleModel.fromEntity(NotificationSchedule entity) {
    return NotificationScheduleModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type.toString().split('.').last,
      mealType: entity.mealType != null
          ? entity.mealType.toString().split('.').last
          : null,
      time: entity.time,
      isEnabled: entity.isEnabled,
      isFastingMode: entity.isFastingMode,
      title: entity.title,
      body: entity.body,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static ReminderType _parseReminderType(String value) {
    return ReminderType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ReminderType.drink,
    );
  }

  static MealType _parseMealType(String value) {
    return MealType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => MealType.breakfast,
    );
  }

  @override
  String toString() =>
      'NotificationScheduleModel(id: $id, userId: $userId, type: $type, mealType: $mealType, time: $time, isEnabled: $isEnabled, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationScheduleModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          time == other.time;

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ time.hashCode;
}

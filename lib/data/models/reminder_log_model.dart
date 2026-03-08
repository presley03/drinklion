import 'package:json_annotation/json_annotation.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/core/config/enums.dart';

part 'reminder_log_model.g.dart';

@JsonSerializable()
class ReminderLogModel {
  final String? id;
  final String? userId;
  final String reminderType;
  final String? mealType;
  final DateTime scheduledTime;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? quantity;
  final String? skippedReason;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReminderLogModel({
    this.id,
    this.userId,
    required this.reminderType,
    this.mealType,
    required this.scheduledTime,
    this.isCompleted = false,
    this.completedAt,
    this.quantity,
    this.skippedReason,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert JSON to ReminderLogModel
  factory ReminderLogModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderLogModelFromJson(json);

  /// Convert ReminderLogModel to JSON
  Map<String, dynamic> toJson() => _$ReminderLogModelToJson(this);

  /// Create copy with modifications
  ReminderLogModel copyWith({
    String? id,
    String? userId,
    String? reminderType,
    String? mealType,
    DateTime? scheduledTime,
    bool? isCompleted,
    DateTime? completedAt,
    String? quantity,
    String? skippedReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reminderType: reminderType ?? this.reminderType,
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

  /// Convert ReminderLogModel to ReminderLog entity
  ReminderLog toEntity() {
    return ReminderLog(
      id: id,
      userId: userId,
      type: _parseReminderType(reminderType),
      mealType: mealType != null ? _parseMealType(mealType!) : null,
      scheduledTime: scheduledTime,
      isCompleted: isCompleted,
      completedAt: completedAt,
      quantity: quantity,
      skippedReason: skippedReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create ReminderLogModel from ReminderLog entity
  factory ReminderLogModel.fromEntity(ReminderLog entity) {
    return ReminderLogModel(
      id: entity.id,
      userId: entity.userId,
      reminderType: entity.type.toString().split('.').last,
      mealType: entity.mealType != null
          ? entity.mealType.toString().split('.').last
          : null,
      scheduledTime: entity.scheduledTime,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
      quantity: entity.quantity,
      skippedReason: entity.skippedReason,
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
      'ReminderLogModel(id: $id, userId: $userId, reminderType: $reminderType, mealType: $mealType, scheduledTime: $scheduledTime, isCompleted: $isCompleted, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderLogModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          reminderType == other.reminderType &&
          scheduledTime == other.scheduledTime;

  @override
  int get hashCode =>
      id.hashCode ^ reminderType.hashCode ^ scheduledTime.hashCode;
}

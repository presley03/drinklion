import 'package:json_annotation/json_annotation.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/core/config/enums.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String gender;
  final String ageRange;
  final List<String> healthConditions;
  final String activityLevel;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.gender,
    required this.ageRange,
    this.healthConditions = const [],
    required this.activityLevel,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Create copy with modifications
  UserModel copyWith({
    String? id,
    String? gender,
    String? ageRange,
    List<String>? healthConditions,
    String? activityLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
      healthConditions: healthConditions ?? this.healthConditions,
      activityLevel: activityLevel ?? this.activityLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert UserModel to UserProfile entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      gender: gender,
      ageRange: _parseAgeRange(ageRange),
      healthConditions: _parseHealthConditions(healthConditions),
      activityLevel: _parseActivityLevel(activityLevel),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create UserModel from UserProfile entity
  factory UserModel.fromEntity(UserProfile entity) {
    return UserModel(
      id: entity.id,
      gender: entity.gender,
      ageRange: entity.ageRange.toString().split('.').last,
      healthConditions: entity.healthConditions
          .map((e) => e.toString().split('.').last)
          .toList(),
      activityLevel: entity.activityLevel.toString().split('.').last,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static AgeRange _parseAgeRange(String value) {
    return AgeRange.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => AgeRange.adult,
    );
  }

  static ActivityLevel _parseActivityLevel(String value) {
    return ActivityLevel.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ActivityLevel.medium,
    );
  }

  static List<HealthCondition> _parseHealthConditions(List<String> values) {
    return values
        .map(
          (value) => HealthCondition.values.firstWhere(
            (e) => e.toString().split('.').last == value,
            orElse: () => HealthCondition.none,
          ),
        )
        .toList();
  }

  @override
  String toString() =>
      'UserModel(id: $id, gender: $gender, ageRange: $ageRange, healthConditions: $healthConditions, activityLevel: $activityLevel, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          gender == other.gender &&
          ageRange == other.ageRange;

  @override
  int get hashCode => id.hashCode ^ gender.hashCode ^ ageRange.hashCode;
}

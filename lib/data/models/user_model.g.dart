// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String?,
  gender: json['gender'] as String,
  ageRange: json['ageRange'] as String,
  healthConditions:
      (json['healthConditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  activityLevel: json['activityLevel'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'gender': instance.gender,
  'ageRange': instance.ageRange,
  'healthConditions': instance.healthConditions,
  'activityLevel': instance.activityLevel,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

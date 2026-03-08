part of 'user_profile_bloc.dart';

/// Base event for UserProfileBloc
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load user profile from storage
class LoadUserProfileEvent extends UserProfileEvent {
  const LoadUserProfileEvent();
}

/// Create new user profile (onboarding)
class CreateUserProfileEvent extends UserProfileEvent {
  final String? gender;
  final String? ageRange;
  final List<String>? healthConditions;
  final String? activityLevel;

  const CreateUserProfileEvent({
    this.gender,
    this.ageRange,
    this.healthConditions,
    this.activityLevel,
  });

  @override
  List<Object?> get props => [
    gender,
    ageRange,
    healthConditions,
    activityLevel,
  ];
}

/// Update user profile
class UpdateUserProfileEvent extends UserProfileEvent {
  final String gender;
  final String ageRange;
  final List<String> healthConditions;
  final String activityLevel;

  const UpdateUserProfileEvent({
    required this.gender,
    required this.ageRange,
    required this.healthConditions,
    required this.activityLevel,
  });

  @override
  List<Object?> get props => [
    gender,
    ageRange,
    healthConditions,
    activityLevel,
  ];
}

/// Delete user profile and all associated data
class DeleteUserProfileEvent extends UserProfileEvent {
  const DeleteUserProfileEvent();
}

/// Check if user has completed onboarding
class CheckOnboardingStatusEvent extends UserProfileEvent {
  const CheckOnboardingStatusEvent();
}

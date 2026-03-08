part of 'user_profile_bloc.dart';

/// Base state for UserProfileBloc
abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

/// Loading state
class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

/// User profile loaded successfully
class UserProfileLoaded extends UserProfileState {
  final UserProfile profile;

  const UserProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// User profile created successfully
class UserProfileCreated extends UserProfileState {
  final UserProfile profile;

  const UserProfileCreated(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// User profile updated successfully
class UserProfileUpdated extends UserProfileState {
  final UserProfile profile;

  const UserProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// User profile deleted successfully
class UserProfileDeleted extends UserProfileState {
  const UserProfileDeleted();
}

/// Onboarding not completed (redirect to onboarding flow)
class OnboardingNotCompleted extends UserProfileState {
  const OnboardingNotCompleted();
}

/// Onboarding completed (can proceed to home screen)
class OnboardingCompleted extends UserProfileState {
  const OnboardingCompleted();
}

/// Error state
class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

/// No user profile found (first time user)
class NoUserProfileFound extends UserProfileState {
  const NoUserProfileFound();
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/core/config/enums.dart';
import 'package:drinklion/core/services/schedule_generation_service.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

/// BLoC for managing user profile operations
class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;
  final ReminderRepository _reminderRepository;

  static AgeRange _parseAgeRange(String value) {
    switch (value) {
      case '5-12':
        return AgeRange.child;
      case '13-18':
        return AgeRange.teen;
      case '19-65':
        return AgeRange.adult;
      case '65+':
        return AgeRange.senior;
      default:
        return AgeRange.adult;
    }
  }

  static ActivityLevel _parseActivityLevel(String value) {
    switch (value) {
      case 'low':
        return ActivityLevel.low;
      case 'medium':
        return ActivityLevel.medium;
      case 'high':
        return ActivityLevel.high;
      default:
        return ActivityLevel.medium;
    }
  }

  static List<HealthCondition> _parseHealthConditions(List<String> values) {
    return values.map((value) {
      switch (value) {
        case 'diabetes':
          return HealthCondition.diabetes;
        case 'asam_urat':
          return HealthCondition.asamUrat;
        case 'hypertension':
          return HealthCondition.hypertension;
        case 'kidney':
          return HealthCondition.kidney;
        default:
          return HealthCondition.none;
      }
    }).toList();
  }

  UserProfileBloc(this._userRepository, this._reminderRepository)
    : super(const UserProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<CreateUserProfileEvent>(_onCreateUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<DeleteUserProfileEvent>(_onDeleteUserProfile);
    on<CheckOnboardingStatusEvent>(_onCheckOnboardingStatus);
  }

  /// Load user profile from database
  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(const UserProfileLoading());

      final profile = await _userRepository.getUserProfile();

      if (profile == null) {
        emit(const NoUserProfileFound());
      } else {
        emit(UserProfileLoaded(profile));
      }
    } on Exception catch (e) {
      logger.e('Error loading user profile', error: e);
      emit(UserProfileError(e.toString()));
    }
  }

  /// Create new user profile (first-time onboarding)
  Future<void> _onCreateUserProfile(
    CreateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(const UserProfileLoading());

      // Parse enums from strings
      final ageRange = _parseAgeRange(event.ageRange ?? '19-65');
      final activityLevel = _parseActivityLevel(
        event.activityLevel ?? 'medium',
      );
      final healthConditions = _parseHealthConditions(
        event.healthConditions ?? [],
      );

      // Create profile with provided data
      final profile = UserProfile(
        id: null,
        gender: event.gender ?? 'male',
        ageRange: ageRange,
        healthConditions: healthConditions,
        activityLevel: activityLevel,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await _userRepository.saveUserProfile(profile);

      // Generate and save default reminder schedule
      try {
        final defaultReminders =
            ScheduleGenerationService.generateDefaultSchedule(profile);
        for (final reminder in defaultReminders) {
          await _reminderRepository.insertReminderLog(reminder);
        }
        logger.i(
          'Generated ${defaultReminders.length} default reminders for new user',
        );
      } on Exception catch (e) {
        logger.w('Error generating default reminders', error: e);
        // Don't fail the profile creation if reminders fail
      }

      emit(UserProfileCreated(profile));
    } on Exception catch (e) {
      logger.e('Error creating user profile', error: e);
      emit(UserProfileError(e.toString()));
    }
  }

  /// Update existing user profile
  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(const UserProfileLoading());

      final currentProfile = await _userRepository.getUserProfile();
      if (currentProfile == null) {
        throw Exception('No user profile found to update');
      }

      final ageRange = _parseAgeRange(event.ageRange);
      final activityLevel = _parseActivityLevel(event.activityLevel);
      final healthConditions = _parseHealthConditions(event.healthConditions);

      final updatedProfile = currentProfile.copyWith(
        gender: event.gender,
        ageRange: ageRange,
        healthConditions: healthConditions,
        activityLevel: activityLevel,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserProfile(updatedProfile);

      emit(UserProfileUpdated(updatedProfile));
    } on Exception catch (e) {
      logger.e('Error updating user profile', error: e);
      emit(UserProfileError(e.toString()));
    }
  }

  /// Delete user profile and all associated data
  Future<void> _onDeleteUserProfile(
    DeleteUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(const UserProfileLoading());

      await _userRepository.deleteUserProfile();

      emit(const UserProfileDeleted());
    } on Exception catch (e) {
      logger.e('Error deleting user profile', error: e);
      emit(UserProfileError(e.toString()));
    }
  }

  /// Check if user has completed onboarding
  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatusEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(const UserProfileLoading());

      final hasCompleted = await _userRepository.hasCompletedOnboarding();

      if (hasCompleted) {
        emit(const OnboardingCompleted());
      } else {
        emit(const OnboardingNotCompleted());
      }
    } on Exception catch (e) {
      logger.e('Error checking onboarding status', error: e);
      emit(UserProfileError(e.toString()));
    }
  }
}

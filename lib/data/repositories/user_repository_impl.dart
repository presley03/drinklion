import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/core/services/user_context_service.dart';
import 'package:drinklion/data/datasources/local_data_source.dart';
import 'package:drinklion/data/models/models.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final LocalDataSource _localDataSource;
  final UserContextService _userContext;

  UserRepositoryImpl(this._localDataSource, this._userContext);

  @override
  Future<UserProfile?> getUserProfile() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) {
        logger.w('No current user set');
        return null;
      }

      final userModel = await _localDataSource.getUserProfile(userId);
      return userModel?.toEntity();
    } catch (e) {
      logger.e('Error getting user profile', error: e);
      rethrow;
    }
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final userModel = UserModel.fromEntity(profile);
      await _localDataSource.saveUserProfile(userModel);
      // Update context with new user ID if this is first time setup
      if (profile.id != null) {
        _userContext.setCurrentUserId(profile.id!);
      }
    } catch (e) {
      logger.e('Error saving user profile', error: e);
      rethrow;
    }
  }

  @override
  Future<UserSettings?> getUserSettings() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) {
        logger.w('No current user set');
        return null;
      }

      final settingsModel = await _localDataSource.getUserSettings(userId);
      return settingsModel?.toEntity();
    } catch (e) {
      logger.e('Error getting user settings', error: e);
      rethrow;
    }
  }

  @override
  Future<void> saveUserSettings(UserSettings settings) async {
    try {
      final settingsModel = UserSettingsModel.fromEntity(settings);
      await _localDataSource.saveUserSettings(settingsModel);
    } catch (e) {
      logger.e('Error saving user settings', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteUserProfile() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) {
        logger.w('No current user to delete');
        return;
      }

      await _localDataSource.clearUserData(userId);
      _userContext.clearCurrentUser();
    } catch (e) {
      logger.e('Error deleting user profile', error: e);
      rethrow;
    }
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) return false;

      final metadata = await _localDataSource.getMetadata(
        'onboarding_completed_$userId',
      );
      return metadata == 'true';
    } catch (e) {
      logger.e('Error checking onboarding status', error: e);
      rethrow;
    }
  }
}

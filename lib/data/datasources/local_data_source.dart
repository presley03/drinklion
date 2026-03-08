import 'package:drinklion/data/models/models.dart';

/// Abstract data source interface for local database operations
abstract class LocalDataSource {
  /// Initialize database
  Future<void> initialize();

  /// Close database connection
  Future<void> close();

  // USER OPERATIONS
  /// Get user profile by ID
  Future<UserModel?> getUserProfile(String userId);

  /// Save user profile (create or update)
  Future<String> saveUserProfile(UserModel user);

  /// Check if user exists
  Future<bool> userExists(String userId);

  /// Delete user profile
  Future<void> deleteUserProfile(String userId);

  // REMINDER LOG OPERATIONS
  /// Create reminder log entry
  Future<String> createReminderLog(ReminderLogModel reminderLog);

  /// Get reminder log by ID
  Future<ReminderLogModel?> getReminderLog(String reminderId);

  /// Get today's reminders
  Future<List<ReminderLogModel>> getTodayReminders(String userId);

  /// Get reminders by date range
  Future<List<ReminderLogModel>> getRemindersByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Mark reminder as completed
  Future<void> completeReminder(String reminderId, {String? quantity});

  /// Mark reminder as skipped
  Future<void> skipReminder(String reminderId, {String? reason});

  /// Get completion rate for today (percentage)
  Future<double> getCompletionRate(String userId);

  /// Delete reminder log
  Future<void> deleteReminderLog(String reminderId);

  // NOTIFICATION SCHEDULE OPERATIONS
  /// Create notification schedule
  Future<String> createNotificationSchedule(NotificationScheduleModel schedule);

  /// Get notification schedules for user
  Future<List<NotificationScheduleModel>> getNotificationSchedules(
    String userId,
  );

  /// Get enabled notification schedules for user
  Future<List<NotificationScheduleModel>> getEnabledNotificationSchedules(
    String userId,
  );

  /// Update notification schedule
  Future<void> updateNotificationSchedule(NotificationScheduleModel schedule);

  /// Delete notification schedule
  Future<void> deleteNotificationSchedule(String scheduleId);

  // USER SETTINGS OPERATIONS
  /// Get user settings
  Future<UserSettingsModel?> getUserSettings(String userId);

  /// Save user settings (create or update)
  Future<String> saveUserSettings(UserSettingsModel settings);

  // METADATA OPERATIONS
  /// Get metadata value by key
  Future<String?> getMetadata(String key);

  /// Set metadata key-value pair
  Future<void> setMetadata(String key, String value);

  // BATCH OPERATIONS
  /// Clear all user data (cascade delete)
  Future<void> clearUserData(String userId);

  /// Clear reminders older than specified days
  Future<void> clearOldReminders(int daysOld);
}

import 'package:drinklion/domain/entities/entities.dart';

/// Repository interface for user profile operations
abstract class UserRepository {
  /// Get user profile from local storage
  Future<UserProfile?> getUserProfile();

  /// Save or update user profile
  Future<void> saveUserProfile(UserProfile profile);

  /// Get user settings
  Future<UserSettings?> getUserSettings();

  /// Save or update user settings
  Future<void> saveUserSettings(UserSettings settings);

  /// Delete user profile and all related data
  Future<void> deleteUserProfile();

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding();
}

/// Repository interface for reminder operations
abstract class ReminderRepository {
  /// Get all reminders for today
  Future<List<ReminderLog>> getTodayReminders();

  /// Get reminders for date range
  Future<List<ReminderLog>> getRemindersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Mark reminder as completed
  Future<void> completeReminder({
    required String reminderId,
    required DateTime completedAt,
  });

  /// Mark reminder as skipped
  Future<void> skipReminder({
    required String reminderId,
    required String reason,
  });

  /// Get completion rate for date
  Future<double> getCompletionRate({required DateTime date});

  /// Get completion rate for week
  Future<double> getWeeklyCompletionRate();

  /// Get completion rate for month
  Future<double> getMonthlyCompletionRate();

  /// Insert reminder log
  Future<void> insertReminderLog(ReminderLog reminder);

  /// Get reminder by id
  Future<ReminderLog?> getReminderById(String id);
}

/// Repository interface for notification operations
abstract class NotificationRepository {
  /// Schedule all notifications based on user profile
  Future<void> scheduleAllNotifications();

  /// Schedule single notification
  Future<void> scheduleNotification(NotificationSchedule schedule);

  /// Get all scheduled notifications
  Future<List<NotificationSchedule>> getAllSchedules();

  /// Update notification schedule
  Future<void> updateSchedule(NotificationSchedule schedule);

  /// Cancel all notifications
  Future<void> cancelAllNotifications();

  /// Cancel single notification
  Future<void> cancelNotification(String scheduleId);

  /// Snooze reminder for 30 minutes
  Future<void> snoozeReminder(String reminderId);
}

import 'package:sqflite/sqflite.dart';
import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/data/database/app_database.dart';
import 'package:drinklion/data/datasources/local_data_source.dart';
import 'package:drinklion/data/models/models.dart';

/// Implementation of LocalDataSource with SQLite database operations
class LocalDataSourceImpl implements LocalDataSource {
  final AppDatabase _appDatabase;

  LocalDataSourceImpl(this._appDatabase);

  late Database _db;

  @override
  Future<void> initialize() async {
    _db = await _appDatabase.getDatabase();
    logger.t('Database initialized');
  }

  @override
  Future<void> close() async {
    await _appDatabase.close();
    logger.t('Database closed');
  }

  // ===== USER OPERATIONS =====

  @override
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final maps = await _db.query(
        'users',
        where: 'id = ?',
        whereArgs: [int.parse(userId)],
      );

      if (maps.isEmpty) {
        return null;
      }

      logger.t('User profile fetched: $userId');
      return UserModel.fromJson(maps.first);
    } catch (e) {
      logger.e('Error getting user profile', error: e);
      rethrow;
    }
  }

  @override
  Future<String> saveUserProfile(UserModel user) async {
    try {
      if (user.id != null) {
        // Update existing user
        await _db.update(
          'users',
          user.toJson()..remove('id'),
          where: 'id = ?',
          whereArgs: [int.parse(user.id!)],
        );
        logger.t('User profile updated: ${user.id}');
        return user.id!;
      } else {
        // Insert new user
        final id = await _db.insert('users', user.toJson());
        logger.t('User profile created: $id');
        return id.toString();
      }
    } catch (e) {
      logger.e('Error saving user profile', error: e);
      rethrow;
    }
  }

  @override
  Future<bool> userExists(String userId) async {
    try {
      final result = await _db.rawQuery(
        'SELECT 1 FROM users WHERE id = ? LIMIT 1',
        [int.parse(userId)],
      );
      return result.isNotEmpty;
    } catch (e) {
      logger.e('Error checking user existence', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [int.parse(userId)],
      );
      logger.t('User profile deleted: $userId');
    } catch (e) {
      logger.e('Error deleting user profile', error: e);
      rethrow;
    }
  }

  // ===== REMINDER LOG OPERATIONS =====

  @override
  Future<String> createReminderLog(ReminderLogModel reminderLog) async {
    try {
      final id = await _db.insert('reminders_log', reminderLog.toJson());
      logger.t('Reminder log created: $id');
      return id.toString();
    } catch (e) {
      logger.e('Error creating reminder log', error: e);
      rethrow;
    }
  }

  @override
  Future<ReminderLogModel?> getReminderLog(String reminderId) async {
    try {
      final maps = await _db.query(
        'reminders_log',
        where: 'id = ?',
        whereArgs: [int.parse(reminderId)],
      );

      if (maps.isEmpty) {
        return null;
      }

      return ReminderLogModel.fromJson(maps.first);
    } catch (e) {
      logger.e('Error getting reminder log', error: e);
      rethrow;
    }
  }

  @override
  Future<List<ReminderLogModel>> getTodayReminders(String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

      final maps = await _db.query(
        'reminders_log',
        where: 'user_id = ? AND scheduled_time BETWEEN ? AND ?',
        whereArgs: [
          int.parse(userId),
          startOfDay.toIso8601String(),
          endOfDay.toIso8601String(),
        ],
        orderBy: 'scheduled_time ASC',
      );

      return maps.map((m) => ReminderLogModel.fromJson(m)).toList();
    } catch (e) {
      logger.e('Error getting today reminders', error: e);
      rethrow;
    }
  }

  @override
  Future<List<ReminderLogModel>> getRemindersByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final maps = await _db.query(
        'reminders_log',
        where: 'user_id = ? AND scheduled_time BETWEEN ? AND ?',
        whereArgs: [
          int.parse(userId),
          startDate.toIso8601String(),
          endDate.toIso8601String(),
        ],
        orderBy: 'scheduled_time DESC',
      );

      return maps.map((m) => ReminderLogModel.fromJson(m)).toList();
    } catch (e) {
      logger.e('Error getting reminders by date range', error: e);
      rethrow;
    }
  }

  @override
  Future<void> completeReminder(String reminderId, {String? quantity}) async {
    try {
      final now = DateTime.now();
      await _db.update(
        'reminders_log',
        {
          'is_completed': 1,
          'completed_at': now.toIso8601String(),
          'quantity': quantity,
          'updated_at': now.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [int.parse(reminderId)],
      );

      logger.t('Reminder completed: $reminderId');
    } catch (e) {
      logger.e('Error completing reminder', error: e);
      rethrow;
    }
  }

  @override
  Future<void> skipReminder(String reminderId, {String? reason}) async {
    try {
      final now = DateTime.now();
      await _db.update(
        'reminders_log',
        {
          'is_completed': 1,
          'completed_at': now.toIso8601String(),
          'skipped_reason': reason,
          'updated_at': now.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [int.parse(reminderId)],
      );

      logger.t('Reminder skipped: $reminderId');
    } catch (e) {
      logger.e('Error skipping reminder', error: e);
      rethrow;
    }
  }

  @override
  Future<double> getCompletionRate(String userId) async {
    try {
      final result = await _db.rawQuery(
        'SELECT COUNT(*) as total, SUM(CASE WHEN is_completed = 1 THEN 1 ELSE 0 END) as completed FROM reminders_log WHERE user_id = ? AND DATE(created_at) = DATE(\'now\')',
        [int.parse(userId)],
      );

      final total = (result[0]['total'] as int?) ?? 0;
      final completed = (result[0]['completed'] as int?) ?? 0;

      if (total == 0) return 0.0;
      return (completed / total) * 100;
    } catch (e) {
      logger.e('Error getting completion rate', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteReminderLog(String reminderId) async {
    try {
      await _db.delete(
        'reminders_log',
        where: 'id = ?',
        whereArgs: [int.parse(reminderId)],
      );

      logger.t('Reminder log deleted: $reminderId');
    } catch (e) {
      logger.e('Error deleting reminder log', error: e);
      rethrow;
    }
  }

  // ===== NOTIFICATION SCHEDULE OPERATIONS =====

  @override
  Future<String> createNotificationSchedule(
    NotificationScheduleModel schedule,
  ) async {
    try {
      final id = await _db.insert('notifications_schedule', schedule.toJson());
      logger.t('Notification schedule created: $id');
      return id.toString();
    } catch (e) {
      logger.e('Error creating notification schedule', error: e);
      rethrow;
    }
  }

  @override
  Future<List<NotificationScheduleModel>> getNotificationSchedules(
    String userId,
  ) async {
    try {
      final maps = await _db.query(
        'notifications_schedule',
        where: 'user_id = ?',
        whereArgs: [int.parse(userId)],
        orderBy: 'time ASC',
      );

      return maps.map((m) => NotificationScheduleModel.fromJson(m)).toList();
    } catch (e) {
      logger.e('Error getting notification schedules', error: e);
      rethrow;
    }
  }

  @override
  Future<List<NotificationScheduleModel>> getEnabledNotificationSchedules(
    String userId,
  ) async {
    try {
      final maps = await _db.query(
        'notifications_schedule',
        where: 'user_id = ? AND is_enabled = 1',
        whereArgs: [int.parse(userId)],
        orderBy: 'time ASC',
      );

      return maps.map((m) => NotificationScheduleModel.fromJson(m)).toList();
    } catch (e) {
      logger.e('Error getting enabled notification schedules', error: e);
      rethrow;
    }
  }

  @override
  Future<void> updateNotificationSchedule(
    NotificationScheduleModel schedule,
  ) async {
    try {
      await _db.update(
        'notifications_schedule',
        schedule.toJson()..remove('id'),
        where: 'id = ?',
        whereArgs: [schedule.id],
      );

      logger.t('Notification schedule updated: ${schedule.id}');
    } catch (e) {
      logger.e('Error updating notification schedule', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteNotificationSchedule(String scheduleId) async {
    try {
      await _db.delete(
        'notifications_schedule',
        where: 'id = ?',
        whereArgs: [int.parse(scheduleId)],
      );

      logger.t('Notification schedule deleted: $scheduleId');
    } catch (e) {
      logger.e('Error deleting notification schedule', error: e);
      rethrow;
    }
  }

  // ===== USER SETTINGS OPERATIONS =====

  @override
  Future<UserSettingsModel?> getUserSettings(String userId) async {
    try {
      final maps = await _db.query(
        'user_settings',
        where: 'user_id = ?',
        whereArgs: [int.parse(userId)],
      );

      if (maps.isEmpty) {
        return null;
      }

      return UserSettingsModel.fromJson(maps.first);
    } catch (e) {
      logger.e('Error getting user settings', error: e);
      rethrow;
    }
  }

  @override
  Future<String> saveUserSettings(UserSettingsModel settings) async {
    try {
      if (settings.id != null) {
        // Update existing settings
        await _db.update(
          'user_settings',
          settings.toJson()..remove('id'),
          where: 'id = ?',
          whereArgs: [int.parse(settings.id!)],
        );

        logger.t('User settings updated: ${settings.id}');
        return settings.id!;
      } else {
        // Insert new settings
        final id = await _db.insert('user_settings', settings.toJson());
        logger.t('User settings created: $id');
        return id.toString();
      }
    } catch (e) {
      logger.e('Error saving user settings', error: e);
      rethrow;
    }
  }

  // ===== METADATA OPERATIONS =====

  @override
  Future<String?> getMetadata(String key) async {
    try {
      final maps = await _db.query(
        'app_metadata',
        where: 'key = ?',
        whereArgs: [key],
      );

      if (maps.isEmpty) {
        return null;
      }

      return maps.first['value'] as String?;
    } catch (e) {
      logger.e('Error getting metadata', error: e);
      rethrow;
    }
  }

  @override
  Future<void> setMetadata(String key, String value) async {
    try {
      await _db.insert('app_metadata', {
        'key': key,
        'value': value,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      logger.t('Metadata set: $key');
    } catch (e) {
      logger.e('Error setting metadata', error: e);
      rethrow;
    }
  }

  // ===== BATCH OPERATIONS =====

  @override
  Future<void> clearUserData(String userId) async {
    try {
      final parsedUserId = int.parse(userId);
      await _db.transaction((txn) async {
        await txn.delete(
          'reminders_log',
          where: 'user_id = ?',
          whereArgs: [parsedUserId],
        );
        await txn.delete(
          'notifications_schedule',
          where: 'user_id = ?',
          whereArgs: [parsedUserId],
        );
        await txn.delete(
          'user_settings',
          where: 'user_id = ?',
          whereArgs: [parsedUserId],
        );
        await txn.delete('users', where: 'id = ?', whereArgs: [parsedUserId]);
      });

      logger.t('User data cleared: $userId');
    } catch (e) {
      logger.e('Error clearing user data', error: e);
      rethrow;
    }
  }

  @override
  Future<void> clearOldReminders(int daysOld) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      await _db.delete(
        'reminders_log',
        where: 'DATE(created_at) < DATE(?)',
        whereArgs: [cutoffDate.toIso8601String()],
      );

      logger.t('Old reminders cleared (older than $daysOld days)');
    } catch (e) {
      logger.e('Error clearing old reminders', error: e);
      rethrow;
    }
  }
}

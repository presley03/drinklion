import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/core/services/user_context_service.dart';
import 'package:drinklion/data/datasources/local_data_source.dart';
import 'package:drinklion/data/models/models.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

/// Implementation of NotificationRepository
class NotificationRepositoryImpl implements NotificationRepository {
  final LocalDataSource _localDataSource;
  final UserContextService _userContext;

  NotificationRepositoryImpl(this._localDataSource, this._userContext);

  @override
  Future<void> scheduleAllNotifications() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) {
        logger.w('No current user for scheduling notifications');
        return;
      }

      // This would typically be called by the notification service
      logger.t('Scheduling all notifications for user: $userId');
    } catch (e) {
      logger.e('Error scheduling all notifications', error: e);
      rethrow;
    }
  }

  @override
  Future<void> scheduleNotification(NotificationSchedule schedule) async {
    try {
      final scheduleModel = NotificationScheduleModel.fromEntity(schedule);
      await _localDataSource.createNotificationSchedule(scheduleModel);
      logger.t('Notification scheduled: ${schedule.id}');
    } catch (e) {
      logger.e('Error scheduling notification', error: e);
      rethrow;
    }
  }

  @override
  Future<List<NotificationSchedule>> getAllSchedules() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) return [];

      final scheduleModels = await _localDataSource.getNotificationSchedules(
        userId,
      );
      return scheduleModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      logger.e('Error getting all notification schedules', error: e);
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(NotificationSchedule schedule) async {
    try {
      final scheduleModel = NotificationScheduleModel.fromEntity(schedule);
      await _localDataSource.updateNotificationSchedule(scheduleModel);
      logger.t('Notification schedule updated: ${schedule.id}');
    } catch (e) {
      logger.e('Error updating notification schedule', error: e);
      rethrow;
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) return;

      final schedules = await _localDataSource.getNotificationSchedules(userId);
      for (final schedule in schedules) {
        await _localDataSource.deleteNotificationSchedule(
          schedule.id ?? 'unknown',
        );
      }

      logger.t('All notifications canceled for user: $userId');
    } catch (e) {
      logger.e('Error canceling all notifications', error: e);
      rethrow;
    }
  }

  @override
  Future<void> cancelNotification(String scheduleId) async {
    try {
      await _localDataSource.deleteNotificationSchedule(scheduleId);
      logger.t('Notification canceled: $scheduleId');
    } catch (e) {
      logger.e('Error canceling notification', error: e);
      rethrow;
    }
  }

  @override
  Future<void> snoozeReminder(String reminderId) async {
    try {
      // Snooze for 30 minutes is typically handled at the notification service level
      logger.t('Reminder snoozed: $reminderId');
    } catch (e) {
      logger.e('Error snoozing reminder', error: e);
      rethrow;
    }
  }
}

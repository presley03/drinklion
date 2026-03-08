import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/core/services/user_context_service.dart';
import 'package:drinklion/data/datasources/local_data_source.dart';
import 'package:drinklion/data/models/models.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

/// Implementation of ReminderRepository
class ReminderRepositoryImpl implements ReminderRepository {
  final LocalDataSource _localDataSource;
  final UserContextService _userContext;

  ReminderRepositoryImpl(this._localDataSource, this._userContext);

  @override
  Future<List<ReminderLog>> getTodayReminders() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) return [];

      final reminderModels = await _localDataSource.getTodayReminders(userId);
      return reminderModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      logger.e('Error getting today reminders', error: e);
      rethrow;
    }
  }

  @override
  Future<List<ReminderLog>> getRemindersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) return [];

      final reminderModels = await _localDataSource.getRemindersByDateRange(
        userId,
        startDate,
        endDate,
      );
      return reminderModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      logger.e('Error getting reminders by date range', error: e);
      rethrow;
    }
  }

  @override
  Future<void> completeReminder({
    required String reminderId,
    required DateTime completedAt,
  }) async {
    try {
      await _localDataSource.completeReminder(reminderId);
    } catch (e) {
      logger.e('Error completing reminder', error: e);
      rethrow;
    }
  }

  @override
  Future<void> skipReminder({
    required String reminderId,
    required String reason,
  }) async {
    try {
      await _localDataSource.skipReminder(reminderId, reason: reason);
    } catch (e) {
      logger.e('Error skipping reminder', error: e);
      rethrow;
    }
  }

  @override
  Future<double> getCompletionRate({required DateTime date}) async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) return 0.0;

      return await _localDataSource.getCompletionRate(userId);
    } catch (e) {
      logger.e('Error getting completion rate', error: e);
      rethrow;
    }
  }

  @override
  Future<double> getWeeklyCompletionRate() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) return 0.0;

      // Get last 7 days reminders
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final reminders = await _localDataSource.getRemindersByDateRange(
        userId,
        sevenDaysAgo,
        now,
      );

      if (reminders.isEmpty) return 0.0;
      final completed = reminders.where((r) => r.isCompleted).length;
      return (completed / reminders.length) * 100;
    } catch (e) {
      logger.e('Error getting weekly completion rate', error: e);
      rethrow;
    }
  }

  @override
  Future<double> getMonthlyCompletionRate() async {
    try {
      final userId = _userContext.getCurrentUserId();
      if (userId == null) return 0.0;

      // Get last 30 days reminders
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      final reminders = await _localDataSource.getRemindersByDateRange(
        userId,
        thirtyDaysAgo,
        now,
      );

      if (reminders.isEmpty) return 0.0;
      final completed = reminders.where((r) => r.isCompleted).length;
      return (completed / reminders.length) * 100;
    } catch (e) {
      logger.e('Error getting monthly completion rate', error: e);
      rethrow;
    }
  }

  @override
  Future<void> insertReminderLog(ReminderLog reminder) async {
    try {
      final reminderModel = ReminderLogModel.fromEntity(reminder);
      await _localDataSource.createReminderLog(reminderModel);
    } catch (e) {
      logger.e('Error inserting reminder log', error: e);
      rethrow;
    }
  }

  @override
  Future<ReminderLog?> getReminderById(String id) async {
    try {
      final reminderModel = await _localDataSource.getReminderLog(id);
      return reminderModel?.toEntity();
    } catch (e) {
      logger.e('Error getting reminder by id', error: e);
      rethrow;
    }
  }
}

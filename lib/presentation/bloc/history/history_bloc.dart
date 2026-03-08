import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

part 'history_event.dart';
part 'history_state.dart';

/// BLoC for managing reminder history and statistics
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ReminderRepository _reminderRepository;

  HistoryBloc(this._reminderRepository) : super(const HistoryInitial()) {
    on<LoadTodayHistoryEvent>(_onLoadTodayHistory);
    on<LoadHistoryByDateEvent>(_onLoadHistoryByDate);
    on<LoadHistoryByRangeEvent>(_onLoadHistoryByRange);
    on<LoadWeeklyStatsEvent>(_onLoadWeeklyStats);
    on<LoadMonthlyStatsEvent>(_onLoadMonthlyStats);
    on<ExportHistoryEvent>(_onExportHistory);
  }

  /// Load history for today
  Future<void> _onLoadTodayHistory(
    LoadTodayHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(const HistoryLoading());

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

      final reminders = await _reminderRepository.getRemindersByDateRange(
        startDate: startOfDay,
        endDate: endOfDay,
      );

      if (reminders.isEmpty) {
        emit(const NoHistoryFound());
      } else {
        final completionRate = await _reminderRepository.getCompletionRate(
          date: today,
        );
        emit(
          HistoryLoaded(
            reminders: reminders,
            statistics: {
              'completionRate': completionRate,
              'totalReminders': reminders.length,
              'completedReminders': reminders
                  .where((r) => r.isCompleted)
                  .length,
            },
          ),
        );
      }
    } catch (e) {
      logger.e('Error loading today history', error: e);
      emit(HistoryError(e.toString()));
    }
  }

  /// Load history for a specific date
  Future<void> _onLoadHistoryByDate(
    LoadHistoryByDateEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(const HistoryLoading());

      final startOfDay = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );
      final endOfDay = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
        23,
        59,
        59,
      );

      final reminders = await _reminderRepository.getRemindersByDateRange(
        startDate: startOfDay,
        endDate: endOfDay,
      );

      if (reminders.isEmpty) {
        emit(const NoHistoryFound());
      } else {
        emit(
          HistoryLoaded(
            reminders: reminders,
            statistics: {
              'totalReminders': reminders.length,
              'completedReminders': reminders
                  .where((r) => r.isCompleted)
                  .length,
              'completionRate': reminders.isEmpty
                  ? 0.0
                  : (reminders.where((r) => r.isCompleted).length /
                            reminders.length) *
                        100,
            },
          ),
        );
      }
    } catch (e) {
      logger.e('Error loading history by date', error: e);
      emit(HistoryError(e.toString()));
    }
  }

  /// Load history for date range
  Future<void> _onLoadHistoryByRange(
    LoadHistoryByRangeEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(const HistoryLoading());

      final reminders = await _reminderRepository.getRemindersByDateRange(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (reminders.isEmpty) {
        emit(const NoHistoryFound());
      } else {
        emit(
          HistoryLoaded(
            reminders: reminders,
            statistics: {
              'totalReminders': reminders.length,
              'completedReminders': reminders
                  .where((r) => r.isCompleted)
                  .length,
              'dateRange': '${event.startDate} - ${event.endDate}',
            },
          ),
        );
      }
    } catch (e) {
      logger.e('Error loading history by range', error: e);
      emit(HistoryError(e.toString()));
    }
  }

  /// Load weekly statistics
  Future<void> _onLoadWeeklyStats(
    LoadWeeklyStatsEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(const HistoryLoading());

      final today = DateTime.now();
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

      final reminders = await _reminderRepository.getRemindersByDateRange(
        startDate: startOfWeek,
        endDate: today,
      );

      if (reminders.isEmpty) {
        emit(const NoHistoryFound());
        return;
      }

      // Calculate daily rates
      final dailyRates = <String, double>{};
      final dayLabels = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

      for (int i = 0; i < 7; i++) {
        final date = startOfWeek.add(Duration(days: i));
        final dayReminders = reminders.where((r) {
          return r.scheduledTime.year == date.year &&
              r.scheduledTime.month == date.month &&
              r.scheduledTime.day == date.day;
        }).toList();

        if (dayReminders.isEmpty) {
          dailyRates[dayLabels[i]] = 0.0;
        } else {
          final completed = dayReminders.where((r) => r.isCompleted).length;
          dailyRates[dayLabels[i]] = (completed / dayReminders.length) * 100;
        }
      }

      final weeklyAverage = dailyRates.values.isNotEmpty
          ? dailyRates.values.reduce((a, b) => a + b) / dailyRates.length
          : 0.0;

      emit(
        WeeklyStatsLoaded(
          dailyRates: dailyRates,
          weeklyAverage: weeklyAverage,
          totalReminders: reminders.length,
          completedReminders: reminders.where((r) => r.isCompleted).length,
        ),
      );
    } catch (e) {
      logger.e('Error loading weekly stats', error: e);
      emit(HistoryError(e.toString()));
    }
  }

  /// Load monthly statistics
  Future<void> _onLoadMonthlyStats(
    LoadMonthlyStatsEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(const HistoryLoading());

      final today = DateTime.now();
      final startOfMonth = DateTime(today.year, today.month, 1);
      final endOfMonth = today;

      final reminders = await _reminderRepository.getRemindersByDateRange(
        startDate: startOfMonth,
        endDate: endOfMonth,
      );

      if (reminders.isEmpty) {
        emit(const NoHistoryFound());
        return;
      }

      // Calculate weekly rates (4-5 weeks)
      final weeklyRates = <String, double>{};

      for (int week = 1; week <= 5; week++) {
        final weekStart = startOfMonth.add(Duration(days: (week - 1) * 7));
        final weekEnd = weekStart.add(const Duration(days: 6));

        final weekReminders = reminders.where((r) {
          return r.scheduledTime.isAfter(weekStart) &&
              r.scheduledTime.isBefore(weekEnd);
        }).toList();

        if (weekReminders.isEmpty) {
          weeklyRates['Week $week'] = 0.0;
        } else {
          final completed = weekReminders.where((r) => r.isCompleted).length;
          weeklyRates['Week $week'] = (completed / weekReminders.length) * 100;
        }
      }

      final monthlyAverage =
          weeklyRates.values
              .where((v) => v > 0)
              .fold<double>(0, (a, b) => a + b) /
          (weeklyRates.values.where((v) => v > 0).length);

      emit(
        MonthlyStatsLoaded(
          weeklyRates: weeklyRates,
          monthlyAverage: monthlyAverage,
          totalReminders: reminders.length,
          completedReminders: reminders.where((r) => r.isCompleted).length,
        ),
      );
    } catch (e) {
      logger.e('Error loading monthly stats', error: e);
      emit(HistoryError(e.toString()));
    }
  }

  /// Export history data
  Future<void> _onExportHistory(
    ExportHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(const HistoryLoading());

      // TODO: Implement export functionality
      // This would typically export data to CSV, PDF, or other formats

      emit(const HistoryExported('/path/to/exported/file'));
    } catch (e) {
      logger.e('Error exporting history', error: e);
      emit(HistoryError(e.toString()));
    }
  }
}

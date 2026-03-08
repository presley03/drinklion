import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/core/config/enums.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

/// BLoC for managing reminder operations
class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository _reminderRepository;

  ReminderBloc(this._reminderRepository) : super(const ReminderInitial()) {
    on<LoadTodayRemindersEvent>(_onLoadTodayReminders);
    on<LoadRemindersByDateRangeEvent>(_onLoadRemindersByDateRange);
    on<CreateReminderEvent>(_onCreateReminder);
    on<CompleteReminderEvent>(_onCompleteReminder);
    on<SkipReminderEvent>(_onSkipReminder);
    on<GetCompletionRateEvent>(_onGetCompletionRate);
    on<DeleteReminderEvent>(_onDeleteReminder);
    on<RefreshRemindersEvent>(_onRefreshReminders);
  }

  /// Load today's reminders
  Future<void> _onLoadTodayReminders(
    LoadTodayRemindersEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      emit(const ReminderLoading());

      final reminders = await _reminderRepository.getTodayReminders();
      final completionRate = await _reminderRepository.getCompletionRate(
        date: DateTime.now(),
      );

      if (reminders.isEmpty) {
        emit(const NoRemindersFound());
      } else {
        emit(
          RemindersLoaded(reminders: reminders, completionRate: completionRate),
        );
      }
    } catch (e) {
      logger.e('Error loading today reminders', error: e);
      emit(ReminderError(e.toString()));
    }
  }

  /// Load reminders by date range
  Future<void> _onLoadRemindersByDateRange(
    LoadRemindersByDateRangeEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      emit(const ReminderLoading());

      final reminders = await _reminderRepository.getRemindersByDateRange(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (reminders.isEmpty) {
        emit(const NoRemindersFound());
      } else {
        emit(RemindersLoaded(reminders: reminders));
      }
    } catch (e) {
      logger.e('Error loading reminders by date range', error: e);
      emit(ReminderError(e.toString()));
    }
  }

  /// Create new reminder
  Future<void> _onCreateReminder(
    CreateReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      emit(const ReminderLoading());

      // Parse reminder type from string
      final reminderType = event.reminderType == 'meal'
          ? ReminderType.meal
          : ReminderType.drink;

      final reminder = ReminderLog(
        id: null,
        scheduledTime: event.scheduledTime,
        type: reminderType,
        isCompleted: false,
        completedAt: null,
        skippedReason: null,
        quantity: null,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await _reminderRepository.insertReminderLog(reminder);

      emit(ReminderCreated(reminder));
    } catch (e) {
      logger.e('Error creating reminder', error: e);
      emit(ReminderError(e.toString()));
    }
  }

  /// Mark reminder as completed
  Future<void> _onCompleteReminder(
    CompleteReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      await _reminderRepository.completeReminder(
        reminderId: event.reminderId,
        completedAt: DateTime.now(),
      );

      emit(ReminderCompleted(event.reminderId));
    } catch (e) {
      logger.e('Error completing reminder', error: e);
      emit(ReminderError(e.toString()));
    }
  }

  /// Mark reminder as skipped
  Future<void> _onSkipReminder(
    SkipReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      await _reminderRepository.skipReminder(
        reminderId: event.reminderId,
        reason: event.reason ?? 'No reason provided',
      );

      emit(ReminderSkipped(event.reminderId));
    } catch (e) {
      logger.e('Error skipping reminder', error: e);
      emit(ReminderError(e.toString()));
    }
  }

  /// Get completion rate
  Future<void> _onGetCompletionRate(
    GetCompletionRateEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      final rate = await _reminderRepository.getCompletionRate(
        date: DateTime.now(),
      );
      emit(CompletionRateRetrieved(rate));
    } catch (e) {
      logger.e('Error getting completion rate', error: e);
      emit(ReminderError(e.toString()));
    }
  }

  /// Delete reminder
  Future<void> _onDeleteReminder(
    DeleteReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      // TODO: Implement delete functionality if available in repository
      emit(const ReminderDeleted());
    } catch (e) {
      logger.e('Error deleting reminder', error: e);
      emit(ReminderError(e.toString()));
    }
  }

  /// Refresh reminders (same as LoadTodayReminders)
  Future<void> _onRefreshReminders(
    RefreshRemindersEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      final reminders = await _reminderRepository.getTodayReminders();
      final completionRate = await _reminderRepository.getCompletionRate(
        date: DateTime.now(),
      );

      if (reminders.isEmpty) {
        emit(const NoRemindersFound());
      } else {
        emit(
          RemindersLoaded(reminders: reminders, completionRate: completionRate),
        );
      }
    } catch (e) {
      logger.e('Error refreshing reminders', error: e);
      emit(ReminderError(e.toString()));
    }
  }
}

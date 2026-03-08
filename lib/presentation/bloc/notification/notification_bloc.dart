import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/core/config/enums.dart';
import 'package:drinklion/core/services/notification_manager.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

part 'notification_event.dart';
part 'notification_state.dart';

/// BLoC for managing notification scheduling
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  final NotificationManager _notificationManager;

  NotificationBloc(this._notificationRepository, this._notificationManager)
    : super(const NotificationInitial()) {
    on<LoadNotificationSchedulesEvent>(_onLoadNotificationSchedules);
    on<CreateNotificationScheduleEvent>(_onCreateNotificationSchedule);
    on<UpdateNotificationScheduleEvent>(_onUpdateNotificationSchedule);
    on<DeleteNotificationScheduleEvent>(_onDeleteNotificationSchedule);
    on<EnableNotificationEvent>(_onEnableNotification);
    on<DisableNotificationEvent>(_onDisableNotification);
    on<ScheduleReminderNotificationsEvent>(_onScheduleReminderNotifications);
    on<CancelNotificationsEvent>(_onCancelNotifications);
  }

  /// Load all notification schedules for user
  Future<void> _onLoadNotificationSchedules(
    LoadNotificationSchedulesEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      final schedules = await _notificationRepository.getAllSchedules();

      if (schedules.isEmpty) {
        emit(const NoNotificationSchedulesFound());
      } else {
        emit(NotificationSchedulesLoaded(schedules));
      }
    } catch (e) {
      logger.e('Error loading notification schedules', error: e);
      emit(NotificationError(e.toString()));
    }
  }

  /// Create new notification schedule
  Future<void> _onCreateNotificationSchedule(
    CreateNotificationScheduleEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      final schedule = NotificationSchedule(
        id: null,
        type: ReminderType.drink,
        time: event.time,
        isEnabled: true,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await _notificationRepository.scheduleNotification(schedule);

      emit(NotificationScheduleCreated(schedule));
    } catch (e) {
      logger.e('Error creating notification schedule', error: e);
      emit(NotificationError(e.toString()));
    }
  }

  /// Update notification schedule
  Future<void> _onUpdateNotificationSchedule(
    UpdateNotificationScheduleEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      final updatedSchedule = event.schedule.copyWith(
        updatedAt: DateTime.now(),
      );

      await _notificationRepository.updateSchedule(updatedSchedule);

      emit(NotificationScheduleUpdated(updatedSchedule));
    } catch (e) {
      logger.e('Error updating notification schedule', error: e);
      emit(NotificationError(e.toString()));
    }
  }

  /// Delete notification schedule
  Future<void> _onDeleteNotificationSchedule(
    DeleteNotificationScheduleEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      await _notificationRepository.cancelNotification(event.scheduleId);

      emit(const NotificationScheduleDeleted());
    } catch (e) {
      logger.e('Error deleting notification schedule', error: e);
      emit(NotificationError(e.toString()));
    }
  }

  /// Enable notification
  Future<void> _onEnableNotification(
    EnableNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      final updatedSchedule = event.schedule.copyWith(
        isEnabled: true,
        updatedAt: DateTime.now(),
      );

      await _notificationRepository.updateSchedule(updatedSchedule);

      emit(NotificationScheduleUpdated(updatedSchedule));
    } catch (e) {
      logger.e('Error enabling notification', error: e);
      emit(NotificationError(e.toString()));
    }
  }

  /// Disable notification
  Future<void> _onDisableNotification(
    DisableNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      final updatedSchedule = event.schedule.copyWith(
        isEnabled: false,
        updatedAt: DateTime.now(),
      );

      await _notificationRepository.updateSchedule(updatedSchedule);

      emit(NotificationScheduleUpdated(updatedSchedule));
    } catch (e) {
      logger.e('Error disabling notification', error: e);
      emit(NotificationError(e.toString()));
    }
  }

  /// Schedule reminder notifications for all enabled schedules
  Future<void> _onScheduleReminderNotifications(
    ScheduleReminderNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      // Initialize timezone data
      NotificationManager.initializeTimezoneData();

      await _notificationRepository.scheduleAllNotifications();
    } catch (e) {
      logger.e('Error scheduling reminders', error: e);
      emit(NotificationError(e.toString()));
    }
  }

  /// Cancel all notifications
  Future<void> _onCancelNotifications(
    CancelNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      // Cancel all notifications in the manager
      await _notificationManager.cancelAllNotifications();

      logger.t('All notifications cancelled');

      emit(const NotificationsCancelled());
    } catch (e) {
      logger.e('Error cancelling notifications', error: e);
      emit(NotificationError(e.toString()));
    }
  }
}

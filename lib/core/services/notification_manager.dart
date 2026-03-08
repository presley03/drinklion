import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tzlib;
import 'package:workmanager/workmanager.dart';

import 'package:drinklion/core/utils/logger.dart';

/// Notification manager using flutter_local_notifications and WorkManager
class NotificationManager {
  // Private constructor for singleton pattern
  NotificationManager._();

  // Singleton instance
  static final NotificationManager _instance = NotificationManager._();

  factory NotificationManager() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize notification manager (must be called before using)
  Future<void> initialize() async {
    if (_isInitialized) {
      logger.t('NotificationManager already initialized');
      return;
    }

    try {
      // Android settings
      const androidInitSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS settings
      const iosInitSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      // Combine settings
      const initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );

      // Initialize plugin
      await _flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );

      // Request permissions (iOS)
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      // Initialize WorkManager for background tasks (with timeout to prevent hanging)
      try {
        await Workmanager()
            .initialize(_callbackDispatcher, isInDebugMode: false)
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                logger.w(
                  'Workmanager initialization timeout - continuing anyway',
                );
              },
            );
      } catch (e) {
        logger.w('Workmanager initialization failed', error: e);
        // Continue even if workmanager fails - app can still work with notifications
      }

      _isInitialized = true;
      logger.i('NotificationManager initialized successfully');
    } catch (e) {
      logger.e('Failed to initialize NotificationManager', error: e);
      rethrow;
    }
  }

  /// Callback handler for notification responses
  static void _handleNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    logger.t('Notification tapped: ${notificationResponse.payload}');
    // Handle notification tap (navigate to relevant screen)
    // This can be used to trigger navigation events
  }

  /// Initialize timezone data (call before scheduling notifications)
  static void initializeTimezoneData() {
    tz.initializeTimeZones();
  }

  /// Send an immediate local notification
  /// Returns the notification ID, or null if not sent (quiet hours/fasting)
  Future<int?> sendNotification({
    required String title,
    required String body,
    required bool notificationSoundEnabled,
    required bool vibrationEnabled,
    bool isQuietHour = false,
    bool isFastingTime = false,
    String? payload,
  }) async {
    if (!_isInitialized) {
      logger.w('NotificationManager not initialized - skipping notification');
      return null;
    }

    // Skip if quiet hours enabled
    if (isQuietHour) {
      logger.t('Skipping notification due to quiet hours');
      return null;
    }

    // Skip if fasting mode enabled
    if (isFastingTime) {
      logger.t('Skipping notification due to fasting mode');
      return null;
    }

    try {
      // Generate notification ID based on current time
      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Android notification details
      final androidDetails = AndroidNotificationDetails(
        'drinklion_channel',
        'DrinkLion Reminders',
        channelDescription: 'Reminders to drink water and eat meals',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        enableVibration: vibrationEnabled,
        vibrationPattern: vibrationEnabled
            ? Int64List.fromList([0, 250, 250, 250])
            : null,
        playSound: notificationSoundEnabled,
        sound: notificationSoundEnabled
            ? const RawResourceAndroidNotificationSound('notification')
            : null,
      );

      // iOS notification details
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Combine details
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Send notification
      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        details,
        payload: payload,
      );

      logger.i('Notification sent: $title');
      return notificationId;
    } catch (e) {
      logger.e('Failed to send notification', error: e);
      return null;
    }
  }

  /// Schedule a notification at specific time
  /// Returns true if successfully scheduled
  Future<bool> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required bool notificationSoundEnabled,
    required bool vibrationEnabled,
    String? payload,
    int? notificationId,
  }) async {
    if (!_isInitialized) {
      logger.w('NotificationManager not initialized - skipping schedule');
      return false;
    }

    try {
      // Generate notification ID if not provided
      final id =
          notificationId ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Convert to timezone-aware time
      final tzScheduledTime = tzlib.TZDateTime.from(scheduledTime, tzlib.local);

      // Android notification details
      final androidDetails = AndroidNotificationDetails(
        'drinklion_channel',
        'DrinkLion Reminders',
        channelDescription: 'Reminders to drink water and eat meals',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        enableVibration: vibrationEnabled,
        vibrationPattern: vibrationEnabled
            ? Int64List.fromList([0, 250, 250, 250])
            : null,
        playSound: notificationSoundEnabled,
      );

      // iOS notification details
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Combine details
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      logger.i('Notification scheduled for $scheduledTime: $title');
      return true;
    } catch (e) {
      logger.e('Failed to schedule notification', error: e);
      return false;
    }
  }

  /// Schedule periodic notifications (using WorkManager)
  /// Note: WorkManager has minimum interval of 15 minutes
  Future<bool> schedulePeriodicReminders({
    required String taskName,
    Duration frequency = const Duration(minutes: 15),
    Map<String, dynamic>? inputData,
  }) async {
    try {
      await Workmanager().registerPeriodicTask(
        taskName,
        'check_reminders',
        frequency: frequency,
        inputData: inputData,
      );

      logger.i('Periodic task registered: $taskName');
      return true;
    } catch (e) {
      logger.e('Failed to schedule periodic task', error: e);
      return false;
    }
  }

  /// Cancel a scheduled notification
  Future<void> cancelNotification(int notificationId) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(notificationId);
      logger.t('Notification cancelled: $notificationId');
    } catch (e) {
      logger.e('Failed to cancel notification', error: e);
    }
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      logger.t('All notifications cancelled');
    } catch (e) {
      logger.e('Failed to cancel all notifications', error: e);
    }
  }

  /// Cancel a periodic task
  Future<void> cancelPeriodicTask(String taskName) async {
    try {
      await Workmanager().cancelByTag(taskName);
      logger.t('Periodic task cancelled: $taskName');
    } catch (e) {
      logger.e('Failed to cancel periodic task', error: e);
    }
  }

  /// Check if a specific time falls within quiet hours
  static bool isQuietHour({
    required String? quietHoursStart,
    required String? quietHoursEnd,
    DateTime? currentTime,
  }) {
    if (quietHoursStart == null || quietHoursEnd == null) {
      return false;
    }

    final now = currentTime ?? DateTime.now();
    final current = TimeOfDay.fromDateTime(now);

    try {
      final startParts = quietHoursStart.split(':');
      final endParts = quietHoursEnd.split(':');

      final start = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );
      final end = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );

      // Handle case where quiet hours span midnight (e.g., 22:00 to 07:00)
      if (start.hour < end.hour ||
          (start.hour == end.hour && start.minute < end.minute)) {
        // Normal case: start < end
        return current.hour > start.hour ||
            (current.hour == start.hour && current.minute >= start.minute) &&
                (current.hour < end.hour ||
                    (current.hour == end.hour && current.minute < end.minute));
      } else {
        // Spanning midnight case
        return current.hour >= start.hour || current.hour < end.hour;
      }
    } catch (e) {
      logger.w('Error parsing quiet hours', error: e);
      return false;
    }
  }

  /// Check if current time falls within fasting period
  static bool isFastingTime({
    required bool fastingModeEnabled,
    required String? fastingStartTime,
    required String? fastingEndTime,
    DateTime? currentTime,
  }) {
    if (!fastingModeEnabled ||
        fastingStartTime == null ||
        fastingEndTime == null) {
      return false;
    }

    final now = currentTime ?? DateTime.now();
    final current = TimeOfDay.fromDateTime(now);

    try {
      final startParts = fastingStartTime.split(':');
      final endParts = fastingEndTime.split(':');

      final start = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );
      final end = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );

      // Handle case where fasting spans midnight
      if (start.hour < end.hour ||
          (start.hour == end.hour && start.minute < end.minute)) {
        // Normal case: start < end
        return current.hour > start.hour ||
            (current.hour == start.hour && current.minute >= start.minute) &&
                (current.hour < end.hour ||
                    (current.hour == end.hour && current.minute < end.minute));
      } else {
        // Spanning midnight case
        return current.hour >= start.hour || current.hour < end.hour;
      }
    } catch (e) {
      logger.w('Error parsing fasting hours', error: e);
      return false;
    }
  }

  /// Get next scheduled notification time
  Future<DateTime?> getNextNotificationTime() async {
    try {
      final pendingNotifications = await _flutterLocalNotificationsPlugin
          .pendingNotificationRequests();
      if (pendingNotifications.isEmpty) {
        return null;
      }

      // Sort by creation time to find earliest
      pendingNotifications.sort((a, b) => a.id.compareTo(b.id));
      return DateTime.fromMillisecondsSinceEpoch(
        pendingNotifications.first.id * 1000,
      );
    } catch (e) {
      logger.e('Error getting next notification time', error: e);
      return null;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      // Cancel WorkManager
      await Workmanager().cancelAll();
      _isInitialized = false;
      logger.t('NotificationManager disposed');
    } catch (e) {
      logger.e('Error disposing NotificationManager', error: e);
    }
  }
}

/// Callback dispatcher for WorkManager background tasks
/// Note: This runs in a separate isolate
void _callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      logger.t('WorkManager task executed: $taskName');

      // TODO: Implement background notification logic
      // This runs in a separate isolate, so you need to:
      // 1. Get the user's reminders from database (via getIt)
      // 2. Check if any reminders need to be notified
      // 3. Call sendNotification for each pending reminder

      return Future.value(true);
    } catch (e) {
      logger.e('Error in background task', error: e);
      return Future.value(false);
    }
  });
}

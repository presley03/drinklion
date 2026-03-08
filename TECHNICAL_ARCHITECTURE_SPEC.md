# Technical Architecture Specification | DrinkLion
## Deep Dive Technical Design & System Flow

**Version:** 1.0  
**Date:** 8 March 2026  
**Target:** Flutter MVP + Health Conditions  

---

## 1. High-Level System Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                        FLUTTER APP LAYER                         │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐  ┌────────┐ │
│  │   Screens   │  │   BLoCs/     │  │  Repositories│  │ Models │ │
│  │  (UI)       │  │  Providers   │  │  (Business   │  │ (Data) │ │
│  └─────────────┘  │  (State Mgmt)│  │   Logic)     │  └────────┘ │
│                   └──────────────┘  └──────────────┘              │
└────────────────┬─────────────────────────────────┬─────────────────┘
                 │                                 │
                 ↓                                 ↓
    ┌────────────────────────┐      ┌──────────────────────────┐
    │  Notification Manager  │      │   Local Storage Layer    │
    │  (flutter_local_       │      │  (SQLite / Hive)         │
    │   notifications)       │      └──────────────────────────┘
    │                        │               │
    │  - Schedule reminders  │               ↓
    │  - Background service  │      ┌──────────────────────┐
    │  - Android WorkManager │      │   SQLite Database    │
    │  - iOS background modes├──────│   (Local Device)     │
    └────────────────────────┘      └──────────────────────┘
                 │
                 ↓
    ┌────────────────────────┐
    │   OS Notification      │
    │   System               │
    │  - Android Notif Mgr   │
    │  - iOS APNS (local)    │
    └────────────────────────┘
```

### Key Design Principles

| Principle | Implementation | Rationale |
|-----------|----------------|-----------|
| **Offline-First** | All data local SQLite, no backend | Privacy, no internet dependency |
| **Separation of Concerns** | BLoC → Repository → DB layer | Testable, maintainable, scalable |
| **State Management via BLoC** | Clear action/event/state flow | Predictable, transparent state changes |
| **Local Notifications** | WorkManager (Android) + CoreLocation (iOS) | Reliable delivery even app killed |
| **Reactive UI** | StreamBuilder/BlocBuilder | Auto-refresh when data changes |

---

## 2. Detailed Component Architecture

### 2.1 Presentation Layer (UI)

```
Screens/
├── splash_screen.dart
├── onboarding/
│   ├── onboarding_screen.dart          # Setup wizard (gender, age, health, activity)
│   ├── health_conditions_selection.dart
│   └── onboarding_bloc.dart
├── home/
│   ├── home_screen.dart                # Today's reminders + quick actions
│   ├── reminder_card.dart              # Reminder UI component
│   ├── fasting_mode_toggle.dart
│   └── home_bloc.dart
├── reminders/
│   ├── reminders_detail_screen.dart    # Show reminder with completed at time
│   └── reminders_bloc.dart
├── settings/
│   ├── settings_screen.dart
│   ├── health_info_modal.dart
│   ├── notification_schedule_settings.dart
│   └── settings_bloc.dart
├── history/
│   ├── history_screen.dart             # Daily/weekly/monthly views
│   ├── history_chart_widget.dart       # Bar chart, pie chart
│   └── history_bloc.dart
├── donation/
│   ├── donation_dialog.dart            # Pop-up donation 1x/month
│   └── donation_payment_screen.dart    # Payment gateway
└── common/
    ├── dialogs.dart                    # Medical disclaimer, confirmation dialogs
    ├── theme.dart                      # Material 3 theme, colors, typography
    └── widgets.dart                    # Reusable components
```

### 2.2 Business Logic Layer (BLoC/State Management)

**Architecture Pattern: BLoC (Business Logic Component)**

```dart
// Example: ReminderBloc
class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository reminderRepository;
  final UserRepository userRepository;
  
  ReminderBloc({
    required this.reminderRepository,
    required this.userRepository,
  }) : super(ReminderInitial()) {
    
    on<FetchTodayReminders>(_onFetchTodayReminders);
    on<CompleteReminder>(_onCompleteReminder);
    on<SnoozeReminder>(_onSnoozeReminder);
    on<UpdateReminderSchedule>(_onUpdateReminderSchedule);
  }
  
  Future<void> _onFetchTodayReminders(
    FetchTodayReminders event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    try {
      final reminders = await reminderRepository.getTodayReminders();
      emit(ReminderLoaded(reminders: reminders));
    } catch (e) {
      emit(ReminderError(message: e.toString()));
    }
  }
  
  // Other event handlers...
}
```

**BLoCs to Implement:**

| BLoC | Events | State | Purpose |
|------|--------|-------|---------|
| **UserProfileBloc** | SetUserProfile, UpdateProfile, FetchProfile | UserProfileLoaded, ProfileUpdating, ProfileError | User info (gender, age, health, activity) |
| **ReminderBloc** | FetchReminders, CompleteReminder, SnoozeReminder, UpdateSchedule | ReminderLoaded, Updating, Error | Manage daily reminders |
| **HistoryBloc** | FetchHistory, FilterByType, SelectDateRange | HistoryLoaded, Loading, Error | Retrieve reminder logs for analytics |
| **SettingsBloc** | UpdateNotificationTime, ToggleSound, ChangeTheme, SetLanguage | SettingsUpdated, Loading, Error | User preferences |
| **FastingBloc** | ToggleFastingMode, SetFastingPeriod, UpdateQuietHours | FastingActive, FastingInactive, Updated | Fasting mode state |
| **NotificationBloc** | ScheduleReminder, RescheduleReminder, CancelReminder | Scheduled, Rescheduled, Error | Notification scheduling logic |

### 2.3 Repository Layer (Data & Business Logic)

```
repositories/
├── abstraction/
│   ├── user_repository.dart           # Abstract class
│   ├── reminder_repository.dart
│   ├── settings_repository.dart
│   └── notification_repository.dart
└── implementation/
    ├── user_repository_impl.dart      # Database operations
    ├── reminder_repository_impl.dart  # CRUD reminders
    ├── settings_repository_impl.dart  # Read/write settings
    └── notification_repository_impl.dart  # Notification scheduling
```

**Repository Responsibilities:**

1. **UserRepository**
   - CRUD user profile (gender, age, health conditions, activity level)
   - Get schedule template based on user category
   - Calculate personalized reminder times

2. **ReminderRepository**
   - Insert/update/delete reminder logs
   - Fetch today's reminders
   - Fetch historical data (weekly, monthly)
   - Calculate completion rate

3. **SettingsRepository**
   - Read/write notification preferences
   - Save theme, language, font size
   - Save fasting mode settings

4. **NotificationRepository**
   - Schedule notifications via WorkManager
   - Reschedule on user action (snooze/complete)
   - Cancel notifications
   - Handle background service

### 2.4 Data Layer (SQLite)

```
data/
├── database/
│   ├── app_database.dart              # Database initialization
│   └── migration_scripts.sql          # Schema versions
├── models/
│   ├── user_model.dart
│   ├── reminder_log_model.dart
│   ├── notification_schedule_model.dart
│   └── settings_model.dart
└── datasources/
    ├── local_data_source.dart          # SQLite interface
    └── local_data_source_impl.dart
```

---

## 3. Notification Scheduling & Background Service

### 3.1 Notification Flow (Android)

```
User sets Profile
   ↓
UserRepository.generateSchedule() → loads template
   ↓
NotificationRepository.scheduleNotifications()
   ↓
WorkManager.enqueueUniquePeriodicWork()
   │
   ├─→ [Repeating] WorkRequest every period
   │   (e.g., daily for breakfast @ 7am)
   │
   ├─→ ExactAlarmScheduler for precise timing
   │   (use setAndAllowWhileIdle for Android 12+)
   │
   └─→ showNotification() [BroadcastReceiver]
       ↓
   OS Notification displayed
   ↓
User taps notification (or notification pops when app closed)
   ↓
Notification action handler:
   - Tap → Open app + navigate to detail screen
   - "Done" button → log completion + reschedule next
   - "Snooze" → reschedule +30 min
```

### 3.2 Android Notification Strategy (Recommended)

```dart
// Use both WorkManager + ExactAlarmManager for reliability
class AndroidNotificationScheduler {
  Future<void> scheduleNotification({
    required String id,
    required DateTime scheduledTime,
    required String title,
    required String body,
    required NotificationType type,
  }) async {
    // 1. Calculate delay from now
    final delay = scheduledTime.difference(DateTime.now());
    
    if (delay.inSeconds < 0) {
      // Notification time passed, reschedule for next day
      return;
    }
    
    // 2. Register with WorkManager (fallback background execution)
    await Workmanager().registerOneOffTask(
      'notification_$id',
      'showNotification',
      initialDelay: delay,
      constraints: Constraints(
        requiresDeviceIdle: false,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresNetwork: false,
      ),
      backoffPolicy: BackoffPolicy.exponential,
    );
    
    // 3. Also use ExactAlarmManager for precise timing
    await AndroidAlarmManager.oneShotAt(
      scheduledTime,
      id.hashCode,
      callbackNotiCallback,
      alarmClock: true,
      wakeup: true,
    );
  }
}
```

### 3.3 iOS Notification Strategy

```swift
// iOS uses UserNotifications framework for local notifications
// Even if app is killed, notification still fires (via system scheduler)

let content = UNMutableNotificationContent()
content.title = "Saatnya Minum Air"
content.body = "Minum 1 gelas air untuk tetap sehat 💪"
content.sound = .default
content.badge = NSNumber(value: 1)

let trigger = UNCalendarNotificationTrigger(
  dateMatching: DateComponents(hour: 9, minute: 0),
  repeats: true  // Daily at 9:00 AM
)

let request = UNNotificationRequest(
  identifier: "drink_9am",
  content: content,
  trigger: trigger
)

UNUserNotificationCenter.current().add(request)
```

### 3.4 Notification Response Handling

```dart
// When app is in foreground or opened from notification:
class NotificationResponseHandler {
  static Future<void> handleNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = jsonDecode(response.payload ?? '{}');
    final reminderId = payload['reminder_id'] as String;
    final action = payload['action'] as String;
    
    if (action == 'complete') {
      // Log completion
      await reminderRepository.completeReminder(reminderId);
      // Show confirmation toast
    } else if (action == 'snooze') {
      // Snooze +30 minutes
      await notificationRepository.snoozeReminder(reminderId);
      // Show "Snoozed until 10:30 AM" toast
    }
  }
}
```

---

## 4. Offline-First Strategy

### 4.1 Data Synchronization (Future v1.1)

For MVP (v1.0), ALL offline. For v1.1 cloud sync:

```
Local SQLite              Cloud Firestore (v1.1)
    ↓                           ↓
    ├─→ [User creates entry]
    │   ├─→ Local insert
    │   ├─→ Mark as "pending_sync"
    │   └─→ Add to sync queue
    │
    ├─→ [Connectivity check]
    │   ├─→ If online: sync queue
    │   ├─→ If offline: queue waits
    │   └─→ Listen to connectivity changes
    │
    └─→ [Sync worker runs]
        ├─→ Batch upload pending changes
        ├─→ Download remote changes
        ├─→ Resolve conflicts (last-write-wins)
        └─→ Mark synced entries
```

### 4.2 Offline-First Guidelines (MVP v1.0)

✅ **Best Practices:**
- Always write to local SQLite first
- UI reads from local DB, not remote
- Queue for sync if backend ever added
- Handle no-internet gracefully (show "saved locally" badge)

❌ **Anti-patterns:**
- Waiting for network before saving
- Blocking UI on cloud operations
- Deleting local data after sync

---

## 5. Health Condition Logic & Schedule Generation

### 5.1 Schedule Template System

```dart
/// Map of health conditions to custom schedules
class ScheduleTemplates {
  static final templates = {
    'normal': ScheduleTemplate(
      waterIntakeFrequency: 8,     // 8 times per day
      waterTimeSlots: [7, 9, 11, 13, 15, 17, 19, 20], // hours
      firstMeal: 7,
      secondMeal: 12,
      thirdMeal: 18,
      notes: 'Standard hydration and meal schedule',
    ),
    
    'diabetes': ScheduleTemplate(
      waterIntakeFrequency: 8,
      waterTimeSlots: [7, 9, 11, 13, 15, 17, 19, 20],
      firstMeal: 7,
      secondMeal: 12,
      thirdMeal: 18,
      notes: 'Maintain consistent meal times. Avoid high sugar intake.',
      specialReminders: ['Check blood sugar daily'],
    ),
    
    'hypertension': ScheduleTemplate(
      waterIntakeFrequency: 6,     // Reduce excess fluid
      waterTimeSlots: [7, 10, 13, 16, 19, 21],
      firstMeal: 7,
      secondMeal: 12,
      thirdMeal: 18,
      notes: 'Low sodium, include potassium-rich foods (banana, leafy greens)',
      specialReminders: ['Check blood pressure daily'],
    ),
    
    'asam_urat': ScheduleTemplate(
      waterIntakeFrequency: 10,    // High hydration
      waterTimeSlots: [6, 8, 10, 12, 14, 16, 18, 20, 21, 22],
      firstMeal: 7,
      secondMeal: 12,
      thirdMeal: 18,
      notes: 'High water intake. Avoid purine-rich foods (organ meat, shellfish)',
      specialReminders: ['Increase water intake'],
    ),
  };
}
```

### 5.2 Personalization Algorithm

```dart
class SchedulePersonalizer {
  /// Generate custom schedule based on user profile
  static List<ReminderSchedule> generateSchedule({
    required UserProfile user,
  }) {
    final template = ScheduleTemplates.templates[user.healthCondition]
        ?? ScheduleTemplates.templates['normal']!;
    
    List<ReminderSchedule> schedule = [];
    
    // Adjust based on activity level
    int waterFrequency = template.waterIntakeFrequency;
    if (user.activityLevel == 'high') {
      waterFrequency += 2;  // Add 2 more glasses for active users
    } else if (user.activityLevel == 'low') {
      waterFrequency -= 1;  // Reduce 1 glass for sedentary
    }
    
    // Adjust based on age
    if (user.ageRange == '65+') {
      // Lansia: slightly less frequency, earlier bedtime
      waterFrequency = max(6, waterFrequency - 1);
    } else if (user.ageRange == '5-12') {
      // Anak: smaller portions, more frequent
      waterFrequency += 2;
    }
    
    // Generate water intake reminders
    final waterTimes = _distributeWaterTimes(waterFrequency);
    for (final hour in waterTimes) {
      schedule.add(ReminderSchedule(
        type: 'drink',
        hour: hour,
        quantity: '1 gelas (250ml)',
        enabled: true,
      ));
    }
    
    // Generate meal reminders
    schedule.addAll([
      ReminderSchedule(type: 'meal', meal: 'breakfast', hour: template.firstMeal),
      ReminderSchedule(type: 'meal', meal: 'lunch', hour: template.secondMeal),
      ReminderSchedule(type: 'meal', meal: 'dinner', hour: template.thirdMeal),
    ]);
    
    return schedule;
  }
  
  static List<int> _distributeWaterTimes(int frequency) {
    // Distribute water intake throughout waking hours (7am - 10pm)
    const wakeHours = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22];
    final interval = wakeHours.length ~/ frequency;
    return wakeHours.where((hour) => wakeHours.indexOf(hour) % interval == 0).toList();
  }
}
```

---

## 6. Notification Permission Handling

### 6.1 Android 13+ Permission Flow

```dart
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionManager {
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    
    if (status.isDenied) {
      // Denied, show manual instructions
      _showEnableNotificationDialog();
      return false;
    } else if (status.isPermanentlyDenied) {
      // Blocked in settings, direct to settings
      openAppSettings();
      return false;
    }
    return true;
  }
  
  static void _showEnableNotificationDialog() {
    // Show dialog explaining why notifications are important
  }
}
```

### 6.2 AndroidManifest.xml Permissions

```xml
<manifest ... >
  <!-- Android 13+ notification permission -->
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
  
  <!-- Exact alarm scheduling (Android 12+) -->
  <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
  
  <!-- Device restart receiver -->
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
  
  <!-- Background execution (Android 6+) -->
  <application>
    <!-- Boot receiver for app restart -->
    <receiver
      android:name=".notification.BootReceiver"
      android:enabled="true"
      android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
      </intent-filter>
    </receiver>
  </application>
</manifest>
```

---

## 7. Data Flow Examples

### 7.1 Complete Reminder Flow

```
┌────────────────────────────────────────────────────────────────┐
│ User taps "Saya sudah minum" button on home screen            │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ HomeScreen calls reminderBloc.add(CompleteReminder(...))      │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ ReminderBloc._onCompleteReminder()                            │
│ - Receive event                                               │
│ - Call reminderRepository.completeReminder()                  │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ ReminderRepository.completeReminder()                         │
│ - Update SQLite: reminders_log.is_completed = true           │
│ - Update reminders_log.completed_at = DateTime.now()         │
│ - Return response                                             │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ ReminderBloc receives updated data                            │
│ - Emit ReminderLoaded state with updated reminders           │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ HomeScreen rebuilds via BlocBuilder                           │
│ - Show ✓ checkmark on completed reminder                     │
│ - Show success toast "Great! Tercatat sudah minum air"       │
└────────────────────────────────────────────────────────────────┘
```

### 7.2 User Profile Setup Flow

```
┌────────────────────────────────────────────────────────────────┐
│ New user opens app                                            │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ OnboardingScreen: 4-step wizard                               │
│ 1. Choose gender (male/female)                               │
│ 2. Choose age range (5-12, 13-18, 19-65, 65+)              │
│ 3. Select health conditions (multi-select)                   │
│ 4. Choose activity level (low/medium/high)                   │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ OnboardingBloc.add(CompleteOnboarding())                      │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ UserRepository.saveUserProfile()                              │
│ - Insert into users table                                     │
│ - Call SchedulePersonalizer.generateSchedule()              │
│ - Get default reminder times                                  │
│ - Insert into notifications_schedule table                    │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ NotificationRepository.scheduleAllReminders()                │
│ - For each reminder in schedule:                             │
│   - Call AndroidNotificationScheduler.scheduleNotification() │
│ - Register with WorkManager                                  │
│ - iOS: UNUserNotificationCenter.add()                        │
└────────────────────────────────────────────────────────────────┘
                             ↓
┌────────────────────────────────────────────────────────────────┐
│ All reminders now active!                                    │
│ Navigate to HomeScreen                                       │
│ First reminder will trigger at scheduled time                │
└────────────────────────────────────────────────────────────────┘
```

---

## 8. Error Handling Strategy

### 8.1 Database Errors

```dart
class DatabaseErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DatabaseException) {
      if (error.isDatabaseClosedError) {
        return 'Database error. Please restart app.';
      } else if (error.isSyntaxError) {
        return 'Data format error. Please contact support.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
```

### 8.2 Notification Errors

```dart
class NotificationErrorHandler {
  static Future<void> handleSchedulingError(dynamic error) async {
    // Log error locally
    logger.e('Notification scheduling failed: $error');
    
    // In future, could also send to analytics
    // analyticsService.logError('notification_scheduling', error);
    
    // Show user-friendly message
    if (error is PlatformException) {
      switch (error.code) {
        case 'PERMISSION_DENIED':
          showDialog('Please enable notifications in settings');
          break;
        case 'SCHEDULING_FAILED':
          showDialog('Failed to schedule reminders. Please retry.');
          break;
      }
    }
  }
}
```

### 8.3 Global Error Handler

```dart
class AppErrorHandler {
  static void setupGlobalErrorHandling() {
    // Dart errors
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.e('Flutter Error', stackTrace: details.stack);
      // Could show error snackbar or dialog
    };
    
    // Platform errors
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      logger.e('Platform Error', stackTrace: stackTrace);
      return true;  // Handled
    };
  }
}
```

---

## 9. Performance Optimization

### 9.1 Database Query Optimization

```dart
// ✓ GOOD: Indexed query
SELECT * FROM reminders_log 
WHERE created_at >= ? 
  AND reminder_type = 'drink'
ORDER BY created_at DESC
LIMIT 100;

// ✗ BAD: Full table scan
SELECT * FROM reminders_log 
WHERE STRFTIME('%Y-%m-%d', created_at) = ?;
```

Indexes to create:
```sql
CREATE INDEX idx_reminders_created_at ON reminders_log(created_at);
CREATE INDEX idx_reminders_type_completed ON reminders_log(reminder_type, is_completed);
CREATE INDEX idx_notifications_enabled ON notifications_schedule(is_enabled);
```

### 9.2 Lazy Loading History

```dart
// Don't load all 90 days at once
// Use pagination: load 7 days initially, then load more on scroll

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  int _currentPage = 0;
  static const _pageSize = 7;
  
  void _onLoadMoreHistory(LoadMoreHistory event, Emitter emit) async {
    final offset = _currentPage * _pageSize;
    final newData = await reminderRepository.getHistoryPaginated(
      offset: offset,
      limit: _pageSize,
    );
    _currentPage++;
    // Append to existing data
  }
}
```

### 9.3 UI Rendering Optimization

```dart
// Use ValueListenableBuilder instead of StreamBuilder when possible
// (Lighter, no stream overhead)

// ✓ GOOD: For simple data changes
ValueListenableBuilder<List<Reminder>>(
  valueListenable: remindersNotifier,
  builder: (_, reminders, __) {
    return ListView(...);
  },
);

// StreamBuilder for complex logic with BLoC
BlocListener<ReminderBloc, ReminderState>(
  listener: (_, state) {
    // Handle state changes
  },
  child: BlocBuilder<ReminderBloc, ReminderState>(
    builder: (_, state) {
      // Build UI
    },
  ),
);
```

---

## 10. Environment Configuration

### 10.1 App Configuration (Local)

```dart
// No backend config needed for MVP!
// Just app-level settings:

class AppConfig {
  static const String appName = 'DrinkLion';
  static const String version = '1.0.0';
  static const int buildNumber = 1;
  
  // Feature flags
  static const bool enableDarkMode = true;
  static const bool enableI18n = true;
  static const bool enableCrashReporting = false;  // For MVP
  static const bool enableAnalytics = false;        // Privacy first!
  
  // DB config
  static const String dbFileName = 'drinklion.db';
  static const int dbVersion = 1;
  
  // Notification config
  static const int notificationPermissionRequestDelay = Duration(seconds: 2);
}
```

---

## 11. Build & Release Configuration

### 11.1 Android Build Setup (build.gradle)

```gradle
android {
    compileSdk 34
    minSdkVersion 21
    targetSdkVersion 34
    
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt')
        }
    }
}
```

### 11.2 iOS Build Setup

```
iOS minimum: 14.0
Capabilities:
- Background Modes: Remote notifications
- User Notifications
```

---

## 12. Dependency Injection Setup

```dart
// Use Get_it for service locator pattern

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Database
  getIt.registerSingleton<AppDatabase>(_initDatabase());
  
  // Data sources
  getIt.registerSingleton<LocalDataSource>(
    LocalDataSourceImpl(database: getIt()),
  );
  
  // Repositories
  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerSingleton<ReminderRepository>(
    ReminderRepositoryImpl(localDataSource: getIt()),
  );
  // ... more repositories
  
  // BLoCs
  getIt.registerSingleton<UserProfileBloc>(
    UserProfileBloc(userRepository: getIt()),
  );
  getIt.registerSingleton<ReminderBloc>(
    ReminderBloc(
      reminderRepository: getIt(),
      userRepository: getIt(),
    ),
  );
  // ... more BLoCs
}
```

---

## 13. Summary: Key Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **State Mgmt** | BLoC | Industry standard, testable, scalable |
| **Local DB** | SQLite | Lightweight, offline, no backend needed |
| **Notifications** | WorkManager + Alarm | Reliable delivery & background execution |
| **Architecture** | Clean Architecture + Repository | Separation of concerns, testable |
| **Dependency Injection** | GetIt | Manual service locator (lightweight) |
| **Error Handling** | Custom handlers per layer | Graceful error recovery |
| **Backend** | None (v1.0) | Privacy-first, simplify MVP |
| **Cloud Sync** | Deferred to v1.1 | Not critical for MVP |

---

**End of Technical Architecture Specification**

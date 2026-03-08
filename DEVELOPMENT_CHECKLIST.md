# DrinkLion - Development Continuation Checklist

## Quick Start
1. Run `flutter pub get`
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Check `flutter analyze` (should be clean)
4. Follow checklist below

---

## Phase 1: Screens (Priority: HIGH)

### 1.1 Navigation Setup
- [ ] Choose navigation package (`go_router` recommended)
- [ ] Create `lib/presentation/routes/` with route definitions
- [ ] Setup app router with authentication gate
- [ ] Create route enums: `AppRoutes` in `lib/core/config/`

### 1.2 OnboardingScreens (4 screens)
**Path**: `lib/presentation/screens/onboarding/`

- [ ] `onboarding_screen.dart` - Main container/controller
- [ ] `gender_selection_screen.dart` - Gender & age range selection
- [ ] `health_conditions_screen.dart` - Multi-select health conditions
- [ ] `activity_level_screen.dart` - Activity level selection
- [ ] `onboarding_complete_screen.dart` - Summary & start button

**Business Logic**:
- Save each step to BLoC
- Validate before proceeding
- Call `UserRepositoryImpl.saveUserProfile()` on complete
- Mark onboarding as complete in metadata

### 1.3 HomeScreen (Main Feature Screen)
**Path**: `lib/presentation/screens/home/`

- [ ] `home_screen.dart` - Main layout
- [ ] `reminder_card_widget.dart` - Reusable reminder item
- [ ] `daily_summary_widget.dart` - Today's stats

**Features**:
- Display today's reminders using `ReminderBloc`
- Show completion percentage
- "Mark Done" button for each reminder
- Quick access to fasting mode toggle
- Bottom navigation to other sections

### 1.4 HistoryScreen
**Path**: `lib/presentation/screens/history/`

- [ ] `history_screen.dart`
- [ ] `statistics_chart_widget.dart` - Using `syncfusion_flutter_charts` or `fl_chart`
- [ ] Date range picker

**Features**:
- Daily/weekly/monthly view
- Completion rate visualization
- Reminder breakdown by type

### 1.5 SettingsScreen
**Path**: `lib/presentation/screens/settings/`

- [ ] `settings_screen.dart`
- [ ] Settings option components
- [ ] Theme toggle
- [ ] Language selector
- [ ] Notification preferences
- [ ] Health info modal

### 1.6 BottomNavigation
- [ ] Create `bottom_nav_bar.dart`
- [ ] Routes: Home, History, Settings
- [ ] Active route highlighting

---

## Phase 2: Notifications (Priority: HIGH)

### 2.1 Setup NotificationManager Service
**Path**: `lib/core/services/notification_manager.dart`

```dart
class NotificationManager {
  Future<void> initializeNotifications() async {
    // Setup flutter_local_notifications
    // Request permissions (Android 13+)
  }
  
  Future<void> scheduleReminder(ReminderLog reminder) async {
    // Schedule using WorkManager (Android)
    // Schedule using FlutterLocalNotifications (iOS)
  }
  
  Future<void> handleNotificationTap(String reminderId) async {
    // Navigate to app with reminder context
  }
}
```

### 2.2 WorkManager Integration (Android)
- [ ] Add `workmanager` configuration in `android/app/build.gradle`
- [ ] Create background task handler
- [ ] Schedule periodic vs one-time tasks
- [ ] Handle permission requests

### 2.3 iOS Local Notifications
- [ ] Configure notification categories
- [ ] Setup notification permissions
- [ ] Test on iOS device

### 2.4 IntegrateNotificationBloc
- [ ] Emit events from notification taps
- [ ] Navigate to relevant screen
- [ ] Update reminder logs

---

## Phase 3: Business Logic (Priority: MEDIUM)

### 3.1 Schedule Generation Algorithm
**File**: `lib/core/services/schedule_service.dart`

Create function:
```dart
List<NotificationSchedule> generateSchedule(UserProfile user) {
  // Based on age range, health conditions, activity level
  // Generate 8 drink reminders + 3 meal times
  // Return list of NotificationSchedule objects
}
```

**Health Conditions Impact**:
- Diabetes: More frequent check-ins, adjust meal timing
- Hypertension: Morning water emphasis, sodium notes
- Asam Urat: Hydration emphasis, protein reminders

### 3.2 Completion Tracking
- [ ] Track completion rate calculation
- [ ] Update ReminderLog.is_completed
- [ ] Calculate streaks

### 3.3 Statistics Service
**File**: `lib/core/services/statistics_service.dart`

- [ ] Daily completion rate
- [ ] Weekly trends
- [ ] Most-completed reminder type
- [ ] Adherence patterns

---

## Phase 4: Testing (Priority: MEDIUM)

### 4.1 Unit Tests
**Path**: `test/`

- [ ] `data/repositories/` - Repository tests
- [ ] `core/services/` - Service tests
- [ ] `presentation/bloc/` - BLoC state tests

Run: `flutter test`

### 4.2 Integration Tests
- [ ] Database CRUD operations
- [ ] Full user flow (onboarding → save profile)
- [ ] Reminder creation & logging

### 4.3 Manual Testing Checklist
- [ ] Onboarding flow saves data
- [ ] Database persists across app restart
- [ ] BLoC states update UI correctly
- [ ] Settings persist
- [ ] Notifications trigger (if device connected)

---

## Phase 5: Polish (Priority: LOW)

### 5.1 UI/UX Polish
- [ ] Add animations/transitions
- [ ] Loading states with shimmer
- [ ] Error handling & user feedback
- [ ] Accessibility (semantic labels, font sizes)

### 5.2 Internationalization (i18n)
- [ ] Add `intl` strings to `lib/core/i18n/`
- [ ] Indonesian (default) + English
- [ ] Language switcher in Settings

### 5.3 Performance
- [ ] Profile with DevTools
- [ ] Lazy load screens
- [ ] Optimize database queries
- [ ] Cache user settings

### 5.4 Release Prep
- [ ] Update app version in `pubspec.yaml`
- [ ] Configure Android signing
- [ ] Setup iOS deployment
- [ ] Test builds: `flutter build apk`, `flutter build ios`

---

## Code Generation & Maintenance

### Always Remember
```bash
# After modifying models or entities
dart run build_runner build --delete-conflicting-outputs

# After adding/removing dependencies
flutter pub get

# Check code quality
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test
```

---

## File Checklist Created vs Needed

### ✅ Already Created
- [x] app_database.dart
- [x] User/Reminder/Settings models
- [x] All BLoCs with events/states
- [x] service_locator.dart
- [x] app_theme.dart
- [x] app_config.dart
- [x] Main entry point (updated)

### ⏳ Need to Create

**Screens** (11 files):
- [ ] `lib/presentation/screens/onboarding/`
- [ ] `lib/presentation/screens/home/`
- [ ] `lib/presentation/screens/history/`
- [ ] `lib/presentation/screens/settings/`
- [ ] `lib/presentation/routes/` (routing setup)

**Services** (2 files):
- [ ] `lib/core/services/notification_manager.dart`
- [ ] `lib/core/services/schedule_service.dart`

**Utilities** (1 file):
- [ ] `lib/core/services/statistics_service.dart`

**Tests** (3-5 files):
- [ ] Database operation tests
- [ ] BLoC tests
- [ ] Service tests

---

## Common Pitfalls to Avoid

1. ❌ Forgetting to run `build_runner` after model changes
2. ❌ Mixing String and TimeOfDay (use String `HH:MM` format)
3. ❌ Direct database access instead of repo pattern
4. ❌ Updating BLoC events without updating handlers
5. ❌ Not testing database transactions before release

---

## Useful Dependencies Already Added

- `flutter_bloc` → State management
- `sqflite` → SQLite database
- `flutter_local_notifications` → Push notifications
- `workmanager` → Background tasks
- `get_it` → Service locator
- `logger` → Logging
- `intl` → Internationalization
- `google_fonts` → Custom fonts

---

## Questions to Answer Before Next Phase

1. What should be default reminder times for each age group?
2. How many reminders per day is optimal?
3. What's the minimum/maximum notification frequency?
4. Should app collect any analytics (check PRD - probably not)?
5. Backup strategy needed?

---

**Total Estimated Time**: 3-5 days with focused work
**Easy Quick Wins**: Screens (forms are straightforward)
**Complex Parts**: Notification scheduling, health algorithms

Good luck! 🦁

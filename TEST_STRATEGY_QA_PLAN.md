# Test Strategy & QA Plan | DrinkLion
## Comprehensive Testing Coverage for MVP

**Version:** 1.0  
**Date:** 8 March 2026  
**Coverage Target:** 80% code coverage (business logic)  
**Release Quality Gate:** 0 critical bugs, <5 high priority  

---

## 1. Testing Strategy Overview

### 1.1 Test Pyramid

```
                    🔺
                  E2E/Manual
                   (10% time)
                 
                  △ △
               Integration
                (15% time)
               
              ▲ ▲ ▲ ▲
            Unit Tests
            (75% time)
            
- Unit: Fast, isolated, high coverage
- Integration: Database + BLoC interactions
- E2E/Manual: Critical user flows, real device
```

### 1.2 Test Coverage Goals

| Layer | Coverage | Method | Tools |
|-------|----------|--------|-------|
| **Business Logic** | 80%+ | Unit tests | flutter_test, mockito |
| **Repositories** | 70%+ | Unit + Integration | sqflite test, mocks |
| **BLoCs** | 80%+ | Unit tests | bloc_test, mockito |
| **UI Screens** | 60%+ | Widget tests | flutter_test |
| **Critical Flows** | 100% | E2E/Manual | Real devices, checklist |

---

## 2. Unit Testing Strategy

### 2.1 What to Unit Test

**✅ Always Test:**
- Business logic (schedule generation, completion calculation)
- Utility functions (date formatting, percentage calculation)
- Model serialization/deserialization (JSON parsing)
- BLoC state transitions
- Repository data operations

**❌ Don't Test (waste of time):**
- Flutter framework code
- Package code (assume tested by maintainers)
- Trivial getters/setters
- UI rendering logic (use widget tests instead)

### 2.2 Unit Test Examples

#### Test: Schedule Generation

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:drinklion/domain/models/user_model.dart';
import 'package:drinklion/domain/services/schedule_service.dart';

void main() {
  group('ScheduleService', () {
    late ScheduleService scheduleService;
    
    setUpAll(() {
      scheduleService = ScheduleService();
    });
    
    test('generateSchedule for normal adult returns 8 drink + 3 meals', () {
      // Arrange
      final user = UserModel(
        gender: 'female',
        ageRange: '19-65',
        healthConditions: [],
        activityLevel: 'medium',
      );
      
      // Act
      final schedule = scheduleService.generateSchedule(user);
      
      // Assert
      expect(schedule, isNotEmpty);
      
      final drinkReminders = schedule.where((r) => r.type == 'drink').toList();
      final mealReminders = schedule.where((r) => r.type == 'meal').toList();
      
      expect(drinkReminders.length, equals(8));
      expect(mealReminders.length, equals(3));
    });
    
    test('generateSchedule for diabetes increases water frequency', () {
      // Arrange
      final user = UserModel(
        gender: 'male',
        ageRange: '19-65',
        healthConditions: ['diabetes'],
        activityLevel: 'medium',
      );
      
      // Act
      final schedule = scheduleService.generateSchedule(user);
      
      // Assert
      final drinkReminders = schedule.where((r) => r.type == 'drink').toList();
      expect(drinkReminders.length, greaterThanOrEqualTo(8));
    });
    
    test('generateSchedule for asam urat maximizes water intake', () {
      final user = UserModel(
        gender: 'female',
        ageRange: '35-65',
        healthConditions: ['asam_urat'],
        activityLevel: 'low',
      );
      
      final schedule = scheduleService.generateSchedule(user);
      
      // Asam urat should have highest water frequency (10+)
      final drinkReminders = schedule.where((r) => r.type == 'drink').toList();
      expect(drinkReminders.length, greaterThanOrEqualTo(10));
    });
    
    test('generateSchedule for child (5-12) includes more frequent snacks', () {
      final user = UserModel(
        gender: 'male',
        ageRange: '5-12',
        healthConditions: [],
        activityLevel: 'high',
      );
      
      final schedule = scheduleService.generateSchedule(user);
      
      final snackReminders = schedule
          .where((r) => r.type == 'meal' && r.mealType == 'snack')
          .toList();
      expect(snackReminders.length, greaterThanOrEqualTo(2));
    });
  });
}
```

#### Test: Completion Rate Calculation

```dart
test('calculateCompletionRate returns correct percentage', () {
  // Arrange
  const totalReminders = 10;
  const completedReminders = 7;
  
  // Act
  final rate = calculateCompletionRate(completedReminders, totalReminders);
  
  // Assert
  expect(rate, equals(70.0));
});

test('calculateCompletionRate handles zero reminders', () {
  // Arrange
  const totalReminders = 0;
  const completedReminders = 0;
  
  // Act & Assert
  expect(
    () => calculateCompletionRate(completedReminders, totalReminders),
    throwsException,
  );
});
```

#### Test: BLoC State Transitions

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:drinklion/presentation/blocs/reminder/reminder_bloc.dart';

void main() {
  group('ReminderBloc', () {
    late MockReminderRepository mockReminderRepository;
    late ReminderBloc reminderBloc;
    
    setUp(() {
      mockReminderRepository = MockReminderRepository();
      reminderBloc = ReminderBloc(
        reminderRepository: mockReminderRepository,
      );
    });
    
    tearDown(() {
      reminderBloc.close();
    });
    
    blocTest<ReminderBloc, ReminderState>(
      'emits [ReminderLoading, ReminderLoaded] when FetchTodayReminders is added',
      build: () {
        when(mockReminderRepository.getTodayReminders())
            .thenAnswer((_) async => [
          Reminder(id: '1', type: 'drink', scheduledTime: DateTime.now()),
          Reminder(id: '2', type: 'meal', scheduledTime: DateTime.now()),
        ]);
        return reminderBloc;
      },
      act: (bloc) => bloc.add(FetchTodayReminders()),
      expect: () => [
        isA<ReminderLoading>(),
        isA<ReminderLoaded>()
            .having((state) => state.reminders.length, 'length', 2),
      ],
    );
    
    blocTest<ReminderBloc, ReminderState>(
      'emits [ReminderLoading, ReminderError] on repository failure',
      build: () {
        when(mockReminderRepository.getTodayReminders())
            .thenThrow(Exception('DB error'));
        return reminderBloc;
      },
      act: (bloc) => bloc.add(FetchTodayReminders()),
      expect: () => [
        isA<ReminderLoading>(),
        isA<ReminderError>(),
      ],
    );
  });
}
```

### 2.3 Mocking Strategy

```dart
// Using mockito
import 'package:mockito/mockito.dart';

// Generate mocks using build_runner
@GenerateMocks([ReminderRepository, UserRepository, NotificationRepository])
void main() {}

// Example: Mock repository method
final mockRepo = MockReminderRepository();
when(mockRepo.getTodayReminders()).thenAnswer((_) async => testReminders);

// Verify mock was called
verify(mockRepo.getTodayReminders()).called(1);
```

---

## 3. Widget Testing Strategy

### 3.1 What to Widget Test

**✅ Widget Test These:**
- Critical user flows (onboarding, reminder completion)
- UI state changes (button enabled/disabled)
- Form validation
- Dialog interactions
- List rendering

### 3.2 Widget Test Examples

#### Test: Onboarding Flow

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:drinklion/main.dart';

void main() {
  group('Onboarding Flow Widget Tests', () {
    testWidgets('User can complete onboarding in 4 steps', (WidgetTester tester) async {
      // Arrange: Load app
      await tester.pumpWidget(DrinkLionApp());
      
      // Act & Assert: Step 1 - Gender Selection
      expect(find.text('Pilih Jenis Kelamin'), findsOneWidget);
      
      await tester.tap(find.text('👩 Female'));
      await tester.pumpAndSettle();
      
      // Verify Next button enabled
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();
      
      // Step 2 - Age Selection
      expect(find.text('Berapa Usia Anda?'), findsOneWidget);
      
      await tester.tap(find.text('19-65 tahun'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();
      
      // Step 3 - Health Conditions
      expect(find.text('Ada Kondisi Kesehatan Khusus?'), findsOneWidget);
      
      await tester.tap(find.byType(Checkbox).first); // Select Diabetes
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();
      
      // Step 4 - Activity Level
      expect(find.text('Seberapa Aktif Anda?'), findsOneWidget);
      
      await tester.tap(find.text('🚶 Medium - Light exercise'));
      await tester.pumpAndSettle();
      
      // Complete
      await tester.tap(find.text('Done ✓'));
      await tester.pumpAndSettle();
      
      // Verify: Now at Home screen
      expect(find.text('Home'), findsWidgets);
    });
    
    testWidgets('Onboarding requires full answers', (WidgetTester tester) async {
      await tester.pumpWidget(DrinkLionApp());
      
      // Try to skip first step without selection
      final nextButton = find.byIcon(Icons.arrow_forward);
      
      // Button should be disabled (if implemented)
      expect(tester.widget<ElevatedButton>(nextButton).enabled, false);
    });
  });
}
```

#### Test: Home Screen Reminder Completion

```dart
testWidgets('User can mark reminder as completed', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(DrinkLionApp(initialRoute: '/home'));
  
  // Find first incomplete reminder
  final reminderCard = find.byType(ReminderCard).first;
  expect(reminderCard, findsOneWidget);
  
  // Act: Tap "Saya sudah" button
  final doneButton = find.byWidgetPredicate(
    (widget) => widget is ElevatedButton && 
        (widget.child as Text).data == 'Saya sudah',
  );
  
  await tester.tap(doneButton);
  await tester.pumpAndSettle();
  
  // Assert: Show confirmation
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('Great! Tercatat sudah minum air'), findsOneWidget);
});
```

#### Test: History Chart Rendering

```dart
testWidgets('History screen displays completion chart', (WidgetTester tester) async {
  await tester.pumpWidget(DrinkLionApp());
  
  // Navigate to History
  await tester.tap(find.byIcon(Icons.history));
  await tester.pumpAndSettle();
  
  // Verify chart exists
  expect(find.byType(BarChart), findsOneWidget);
  
  // Verify data points
  expect(find.byType(BarChartRodData), findsWidgets);
  
  // Verify labels (days of week)
  expect(find.text('Mon'), findsOneWidget);
  expect(find.text('Fri'), findsOneWidget);
});
```

### 3.3 Form Validation Testing

```dart
testWidgets('Settings form validates notification times', (WidgetTester tester) async {
  await tester.pumpWidget(DrinkLionApp(initialRoute: '/settings'));
  
  // Arrange: Navigate to time picker
  await tester.tap(find.text('Customize reminder times'));
  await tester.pumpAndSettle();
  
  // Act: Enter invalid time (end time before start time)
  final startField = find.byType(TextField).first;
  await tester.enterText(startField, '14:00');
  
  final endField = find.byType(TextField).at(1);
  await tester.enterText(endField, '13:00');
  
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
  
  // Assert: Show error
  expect(find.text('End time must be after start time'), findsOneWidget);
});
```

---

## 4. Integration Testing

### 4.1 Integration Test Scope

**Integration tests cover:**
- User profile setup → notification scheduling
- Reminder completion → history update
- Settings change → notification reschedule
- Fasting mode → silent notifications

### 4.2 Integration Test Example

```dart
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drinklion/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('User Reminder Completion Integration Test', () {
    testWidgets('Complete flow: Setup → Reminder → Completion', 
      (WidgetTester tester) async {
      
      // Step 1: Load app
      await tester.pumpWidget(DrinkLionApp());
      await tester.pumpAndSettle(Duration(seconds: 2));
      
      // Step 2: Complete onboarding
      await tester.tap(find.text('👩 Female'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward));
      
      await tester.tap(find.text('19-65 tahun'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward));
      
      await tester.tap(find.text('Tidak ada'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward));
      
      await tester.tap(find.text('🚶 Medium'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done ✓'));
      await tester.pumpAndSettle(Duration(seconds: 1));
      
      // Step 3: Verify notifications scheduled
      // (Check notifications_schedule table in DB)
      
      // Step 4: Mark reminder as completed
      final reminderCard = find.byType(ReminderCard).first;
      expect(reminderCard, findsOneWidget);
      
      final doneButton = find.byWidgetPredicate(
        (widget) => widget is ElevatedButton && 
            (widget.child as Text).data == 'Saya sudah',
      );
      
      await tester.tap(doneButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      
      // Step 5: Verify completion logged in DB
      // (Check reminders_log table: is_completed = true)
      
      // Step 6: Check history view updated
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      
      // Verify completion appears in history
      expect(find.text('✓ Saya sudah minum'), findsOneWidget);
    });
  });
}
```

---

## 5. Manual QA Testing

### 5.1 Manual Testing Checklist (Critical Flows)

#### **ONBOARDING**
- [ ] Welcome screen loads correctly
- [ ] All 4 steps complete without error
- [ ] Back button works on steps 2-4
- [ ] Skip button skips to home
- [ ] Invalid selections prevented
- [ ] Health condition disclaimer shows
- [ ] Notifications scheduled immediately after onboarding

#### **HOME SCREEN**
- [ ] Today's reminders load
- [ ] Reminders sort by time (earliest first)
- [ ] Completed reminders show checkmark & grayed out
- [ ] Upcoming reminder shows countdown timer
- [ ] "Saya sudah" button completes reminder
- [ ] "Snooze" button reschedules +30 min
- [ ] Tap reminder shows detail modal
- [ ] Completion rate badge shows correct %
- [ ] Fasting mode toggle works
- [ ] Pull-to-refresh reloads data

#### **NOTIFICATIONS**
- [ ] Notification arrives at scheduled time ✓
- [ ] Notification title & body display correctly
- [ ] Tap notification opens app to detail screen
- [ ] "Done" button from notification completes reminder
- [ ] Notification sound plays (if enabled in settings)
- [ ] Vibration triggers (if enabled in settings)
- [ ] Quiet hours respected (no notifications 10pm-7am)
- [ ] Fasting mode: notification silent ✓
- [ ] Notification persists if app doesn't respond

#### **HISTORY**
- [ ] Weekly view shows last 7 days
- [ ] Monthly view shows entire month
- [ ] Completion chart displays correctly
- [ ] Bars/lines represent correct percentages
- [ ] Filter by drink/meals works
- [ ] Date detail view shows all reminders
- [ ] Scrolling loads more data (pagination)

#### **SETTINGS**
- [ ] All settings options visible
- [ ] Toggle settings save correctly
- [ ] Theme changes apply immediately (light/dark)
- [ ] Font size scaling works
- [ ] Language switch works (ID/EN)
- [ ] Notification time picker works
- [ ] Quiet hours customizable
- [ ] Fasting mode date picker works
- [ ] Health info modal displays correctly

#### **DATA INTEGRITY**
- [ ] Data persists after app close/reopen
- [ ] Reminders continue after 24 hours
- [ ] History accurate across days
- [ ] Export data creates valid JSON file
- [ ] Import data restores correctly
- [ ] Delete data clears all entries

---

### 5.2 Device & OS Compatibility Matrix

**Android Testing:**

| Device | OS | Status | Notes |
|--------|----|----|-------|
| Pixel 4a (Physical) | Android 13 | CRITICAL | Primary device, full testing |
| Pixel 5 (Emulator) | Android 14 | CRITICAL | Notifications, WorkManager |
| Samsung Galaxy S20 | Android 12 | HIGH | OneUI quirks, notification handling |
| Xiaomi Redmi Note 11 | Android 11 | HIGH | Budget device performance |
| Android 10 (Emulator) | Android 10 | MEDIUM | Min OS version compliance |

**iOS Testing: (if built)**

| Device | OS | Status | Notes |
|--------|----|----|-------|
| iPhone 14 (Simulator) | iOS 16 | CRITICAL | Primary device |
| iPhone SE (Simulator) | iOS 15 | HIGH | Smaller screen (4.7") |
| iPhone 12 Mini (Physical) | iOS 15 | MEDIUM | Real device if available |

**Screen Sizes:**

| Size | Device | Target |
|------|--------|--------|
| Small (4.5") | Pixel 3a | Tested |
| Medium (5.5") | Pixel 4a | Primary |
| Large (6.1") | Pixel 6 | Tested |
| Tablet (10") | Any | Responsive check |

---

### 5.3 Performance Testing

#### **Notification Delivery (Latency)**

```
Test: Schedule 50 reminders, check delivery time
Expected: 95% delivered within 2 seconds of scheduled time
Tolerance: ±5 seconds for system load
Tool: Firebase Testlab or manual with 10 devices
```

#### **History Chart Rendering (90 days)**

```
Test: Load 90 days of reminder data (630 reminders)
Expected: Chart renders in <500ms
Max acceptable: <1 second

Measurement: 
  Profile.begin('history_chart_render');
  // ... render chart
  Profile.end('history_chart_render');
```

#### **Database Query Performance**

```
Test: Get today's reminders ($query_today)
Expected: <100ms
Verify with: 
  SELECT EXPLAIN QUERY PLAN $query;
  
Test: Calculate weekly completion rate
Expected: <200ms

Test: Export 90 days data to JSON
Expected: <2 seconds
Max file size: <2MB
```

#### **App Startup Time**

```
Test: Cold start (app not in memory)
Target: <3 seconds to Home screen
Target: <2 seconds to onboarding

Measurement: logger.i('App startup: $ms');
```

---

## 6. Automated Test Execution

### 6.1 GitHub Actions CI/CD Pipeline

```yaml
name: Flutter Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.13.0'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Unit & Widget Tests
      run: |
        flutter test \
          --coverage \
          --test-randomize-ordering-seed random
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        files: ./coverage/lcov.info
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Integration Tests (Firebase Testlab)
      run: |
        firebase test android run \
          --type instrumentation \
          --app build/app/outputs/apk/release/app-release.apk \
          --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
          --device model=Pixel5,version=30,locale=en,orientation=portrait
```

### 6.2 Test Command Examples

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/domain/services/schedule_service_test.dart

# Run tests matching pattern
flutter test --name="should calculate"

# Widget tests only
flutter test test/presentation/screens/

# Run with different seed (randomize)
flutter test --test-randomize-ordering-seed random

# Integration tests
flutter drive --target=test_driver/app.dart

# Firebase Testlab
firebase test android run --app=build/outputs/apk/release/app-release.apk
```

---

## 7. Bug Severity & Triage

### 7.1 Bug Severity Levels

| Level | Impact | Example | Fix ASAP |
|-------|--------|---------|----------|
| **P0 (Critical)** | App crash, data loss, security | App crashes on notification tap | ✅ Before release |
| **P1 (High)** | Feature broken, notification doesn't work | Reminders don't trigger on Android 12+ | ✅ Before release |
| **P2 (Medium)** | Feature partially broken, UI glitch | Chart shows wrong numbers on scroll | ⏰ Next minor release |
| **P3 (Low)** | Minor UX issue, typo | Button color slightly off | ⏰ Nice to fix |
| **P4 (Trivial)** | Documentation, future enhancement | Tooltip missing | ❌ Not critical |

### 7.2 Triage Process

```
Bug Reported → Reproduce → Assign Priority → Assign Owner → Track Fix

Examples:
P0: "App crashes when user taps reminder notification"
  Reproduce: CRITICAL - every time
  Fix: High
  Release: Block MVP

P2: "History chart doesn't animate on first load"
  Reproduce: Sometimes
  Fix: Medium
  Release: v1.0.1 (patch)

P3: "Settings page title alignment off by 1px"
  Reproduce: Visible on tablet only
  Fix: Low
  Release: v1.1 (minor)
```

---

## 8. Release Gate Criteria

**Beta Release Criteria (v1.0-beta):**
- [ ] 80%+ code coverage (business logic)
- [ ] 0 P0 bugs
- [ ] <3 P1 bugs
- [ ] All critical flows tested (manual + automated)
- [ ] Notifications tested on Android 12+, iOS 15+
- [ ] Offline-first feature verified
- [ ] Medical disclaimer displayed
- [ ] Privacy policy stated
- [ ] Performance: App startup <3s, chart render <500ms

**General Release Criteria (v1.0):**
- [ ] P0 bugs: 0
- [ ] P1 bugs: 0
- [ ] P2 bugs: <5
- [ ] D7 retention >30% (from beta data)
- [ ] Crash rate <0.5%
- [ ] Average rating ≥4.0 stars (beta feedback)
- [ ] Play Store submission requirements met
- [ ] All localizations tested (Indonesian + English)

---

## 9. Test Environment Setup

### 9.1 Local Test Setup

```bash
# Install dependencies
flutter pub get

# Generate mocks
dart run build_runner build --delete-conflicting-outputs

# Run tests with watch mode
dart run test --watch

# Generate coverage report
flutter test --coverage
lcov --list coverage/lcov.info
```

### 9.2 Firebase Testlab Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Build test APK
flutter build apk --debug

# Create AndroidTest APK
flutter drive --target=test_driver/app.dart --debug --no-build

# Run on Testlab
firebase test android run \
  --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/outputs/bundleDebugAndroidTest/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk
```

---

## 10. Test Documentation

### 10.1 Test Report Template

```markdown
## Test Run Report - DrinkLion v1.0.0
Date: 2026-03-XX
Duration: 2 hours
Tester: [Name]

### Test Environment
- Device: Pixel 5 (Android 13)
- App Build: 1.0.0-beta.1
- Test Type: Manual + Automated

### Results
| Test Area | Status | Issues |
|-----------|--------|--------|
| Onboarding | ✅ PASS | None |
| Home Screen | ✅ PASS | Minor UI spacing |
| Notifications | ✅ PASS | None |
| History | ⚠️ PARTIAL | Chart label overlap on tablet |
| Settings | ✅ PASS | None |

### Critical Findings
None

### Bugs Found
1. **P2**: History chart labels overlap on tablet landscape
   - Reproducible: Always
   - Expected: Labels should not overlap
   - Actual: Labels overlapping
   - Fix: Adjust font size or rotation

### Sign-Off
- Ready for release: YES / NO
- Release blocked by: [None / Issues]
- Recommendation: Proceed to Play Store
```

---

## 11. Summary: Pre-Release Checklist

**1 Week Before MVP Release:**
- [ ] All unit tests passing (80%+ coverage)
- [ ] All widget tests passing
- [ ] Firebase Testlab results: 0 crashes
- [ ] Manual testing on ≥3 Android devices
- [ ] Performance profiling: App startup <3s
- [ ] Notification testing on Android 10-14
- [ ] Offline sync verification
- [ ] Data export/import tested
- [ ] Medical disclaimer reviewed
- [ ] Privacy policy finalized
- [ ] Play Store screenshots prepared
- [ ] App Store submission metadata ready

**Release Day:**
- [ ] Final code review complete
- [ ] All tests passing in main branch
- [ ] Build signed & verified
- [ ] Version bumped (1.0.0)
- [ ] Changelog written
- [ ] Upload to Play Store (5% staged rollout)
- [ ] Monitor crash reports first 24h
- [ ] Have rollback plan ready

---

**End of Test Strategy & QA Plan**

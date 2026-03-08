# Architecture Overview

DrinkLion follows **Clean Architecture** principles with clear separation of concerns across four distinct layers.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  (Screens, Widgets, BLoCs - User Interaction & State Mgmt)  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Screens:          BLoCs:              Widgets:              │
│  - SplashScreen    - UserProfileBloc   - CustomButton        │
│  - HomeScreen      - ReminderBloc      - ReminderCard        │
│  - SettingsScreen  - NotificationBloc  - ThemeToggle         │
│  - HistoryScreen   - SettingsBloc                            │
│                    - FastingBloc                             │
│                    - HistoryBloc                             │
│                                                              │
└────────────────────────────┬─────────────────────────────────┘
                             │ Events/States
┌────────────────────────────▼─────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  (Business Logic & Rules - Entities & Repository Interfaces)│
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Entities:          Repositories (Interfaces):               │
│  - User             - UserRepository                         │
│  - Reminder         - ReminderRepository                    │
│  - NotificationSchedule - NotificationRepository           │
│  - ReminderLog                                              │
│  - UserSettings                                             │
│                                                              │
└────────────────────────────┬─────────────────────────────────┘
                             │ Implements/Uses
┌────────────────────────────▼─────────────────────────────────┐
│                       DATA LAYER                             │
│  (Data Access - Models, DataSources, Repository Impl)       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Models:            DataSources:       Repositories:         │
│  - UserModel        - LocalDataSource  - UserRepositoryImpl   │
│  - ReminderModel    - LocalDataSourceImpl - ReminderRepoImpl   │
│  - SettingsModel                                             │
│  - LogModel                                                  │
│           ↓                                                  │
│    DATABASE: SQLite │ → NotificationRepositoryImpl            │
│                                                              │
└────────────────────────────┬─────────────────────────────────┘
                             │
┌────────────────────────────▼─────────────────────────────────┐
│                       CORE LAYER                             │
│  (Shared Utilities - Theme, Config, Services, Utils)        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Services:          Config:            Utils:                │
│  - NotificationMgr  - Enums            - Logger              │
│  - UserContextSvc   - AppConfig        - Extensions          │
│  - ServiceLocator                                            │
│                                                              │
│  Theme:                                                      │
│  - AppTheme (Light & Dark)                                  │
│  - Material Design 3 Styling                                │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Dependency Direction

```
Presentation → Domain ← Data
      ↓
   Core (never imports Presentation/Domain/Data)
```

**Golden Rule:** Flow is always downward. Never import upward.
- ✅ Presentation can import Domain
- ❌ Domain cannot import Presentation
- ✅ Data can import Domain
- ❌ Domain cannot import Data

## Layer Details

### 1. Presentation Layer

**Location:** `lib/presentation/`

**Responsibility:** Handle UI and user interaction

**Components:**
- **Screens** - Full page widgets (home, settings, history)
- **Widgets** - Reusable UI components
- **BLoCs** - State management using BLoC pattern

**Dependencies:** Domain, Core

**Example Structure:**
```
presentation/
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   └── history/
│       └── history_screen.dart
└── bloc/
    ├── user_profile/
    │   ├── user_profile_bloc.dart
    │   ├── user_profile_event.dart
    │   └── user_profile_state.dart
    ├── reminder/
    ├── notification/
    ├── settings/
    ├── fasting/
    └── history/
```

**State Management with BLoC:**

Each BLoC has:
- **Bloc** - Event handler, state manager
- **Event** - User actions (ConcreteEvent(data) extends UserProfileEvent)
- **State** - UI states (InitialState, LoadingState, SuccessState)

```dart
// Example BLoC Pattern
context.read<UserProfileBloc>().add(const CheckOnboardingStatusEvent());

// Listen to states
BlocListener<UserProfileBloc, UserProfileState>(
  listener: (context, state) {
    if (state is OnboardingCompleted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  },
)
```

### 2. Domain Layer

**Location:** `lib/domain/`

**Responsibility:** Define business logic contracts and entities

**Components:**
- **Entities** - Pure Dart classes representing domain concepts
- **Repositories** - Abstract interfaces (contracts) for data access

**Dependencies:** None (depends on nothing, depended on by everything)

**Example Structure:**
```
domain/
├── entities/
│   └── entities.dart (User, Reminder, UserSettings, ReminderLog)
└── repositories/
    └── repositories.dart (UserRepository, ReminderRepository interfaces)
```

**Key Principle:** Domain entities are pure business logic, independent of framework/technology.

```dart
// Domain Entity - Technology agnostic
abstract class User {
  String get id;
  String get name;
  int? get age;
  DateTime get createdAt;
}
```

### 3. Data Layer

**Location:** `lib/data/`

**Responsibility:** Implement data access and persistence

**Components:**
- **Models** - JSON-serializable data representations
- **DataSources** - Direct database/API access
- **Repositories** - Implement domain repository interfaces

**Dependencies:** Domain, Core

**Example Structure:**
```
data/
├── database/
│   └── app_database.dart (SQLite setup)
├── datasources/
│   ├── local_data_source.dart (interface)
│   └── local_data_source_impl.dart (implementation)
├── models/
│   ├── user_model.dart (with .g.dart serialization)
│   ├── reminder_model.dart
│   ├── settings_model.dart
│   └── log_model.dart
└── repositories/
    ├── user_repository_impl.dart
    ├── reminder_repository_impl.dart
    └── notification_repository_impl.dart
```

**Database Operations:**
```dart
// Example Data Layer Pattern
abstract class LocalDataSource {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
}

class LocalDataSourceImpl implements LocalDataSource {
  // Implement with SQLite operations
}
```

### 4. Core Layer

**Location:** `lib/core/`

**Responsibility:** Provide shared utilities, configuration, services

**Components:**
- **Services** - Singletons (NotificationManager, UserContextService)
- **Theme** - Material Design 3 styling
- **Config** - Enums, constants, configuration
- **Utils** - Logger, extensions, helpers

**Dependencies:** None (independent)

**Example Structure:**
```
core/
├── services/
│   ├── service_locator.dart (GetIt setup)
│   ├── notification_manager.dart
│   └── user_context_service.dart
├── theme/
│   └── app_theme.dart
│   └── (Material 3 light/dark theming)
├── config/
│   ├── enums.dart
│   └── app_config.dart
└── utils/
    └── logger.dart
```

## Data Flow

### Example: User Sets Reminder

```
1. User taps "Add Reminder" button
   ↓
2. ReminderScreen emits ReminderCreatedEvent to ReminderBloc
   ↓
3. ReminderBloc processes event:
   - Calls ReminderRepository.createReminder(reminder)
   ↓
4. ReminderRepositoryImpl (Data Layer):
   - Converts Reminder (domain) to ReminderModel (data)
   - Calls LocalDataSource.insertReminder(model)
   ↓
5. LocalDataSourceImpl:
   - Executes SQLite INSERT query
   - Returns success/error
   ↓
6. Repository returns to BLoC
   ↓
7. BLoC emits SuccessState
   ↓
8. Screen updates UI, shows confirmation
```

## Dependency Injection

Uses **GetIt** service locator for dependency management:

```dart
// Setup in service_locator.dart
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Singletons
  getIt.registerSingleton<UserContextService>(UserContextService());
  getIt.registerSingleton<NotificationManager>(NotificationManager());
  
  // Repositories
  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(getIt<LocalDataSource>())
  );
  
  // BLoCs
  getIt.registerSingleton<UserProfileBloc>(
    UserProfileBloc(getIt<UserRepository>())
  );
}

// Usage
final repository = getIt<UserRepository>();
```

## State Management: BLoC Pattern

### How BLoC Works

```dart
// 1. Define Events (User actions)
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}

class CheckOnboardingStatusEvent extends UserProfileEvent {
  const CheckOnboardingStatusEvent();
  
  @override
  List<Object?> get props => [];
}

// 2. Define States (UI representations)
abstract class UserProfileState extends Equatable {
  const UserProfileState();
}

class UserProfileInitial extends UserProfileState {
  @override
  List<Object?> get props => [];
}

class OnboardingCompleted extends UserProfileState {
  @override
  List<Object?> get props => [];
}

// 3. Create BLoC (Business Logic)
class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;
  
  UserProfileBloc(this._userRepository) : super(UserProfileInitial()) {
    on<CheckOnboardingStatusEvent>(_onCheckOnboardingStatus);
  }
  
  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatusEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final user = await _userRepository.getUser();
    if (user != null) {
      emit(OnboardingCompleted());
    } else {
      emit(NoUserProfileFound());
    }
  }
}

// 4. Use in UI
context.read<UserProfileBloc>().add(CheckOnboardingStatusEvent());

BlocListener<UserProfileBloc, UserProfileState>(
  listener: (context, state) {
    if (state is OnboardingCompleted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  },
)
```

## Testing Strategy

### Unit Tests (Domain & Data layers)

```dart
// Domain: Pure logic tests - no Flutter/framework
test('isQuietHour returns true when current time in quiet hours', () {
  // Arrange
  final currentTime = TimeOfDay(hour: 22, minute: 0);
  
  // Act
  final result = NotificationManager.isQuietHour(
    quietHoursStart: '21:00',
    quietHoursEnd: '08:00',
    currentTime: DateTime(2024, 1, 1, 22, 0),
  );
  
  // Assert
  expect(result, isTrue);
});
```

### BLoC Tests

```dart
blocTest<ReminderBloc, ReminderState>(
  'emits [ReminderLoadingState, ReminderLoadedState] when reminder loaded',
  build: () => ReminderBloc(mockRepository),
  act: (bloc) => bloc.add(LoadRemindersEvent()),
  expect: () => [
    ReminderLoadingState(),
    ReminderLoadedState([reminder1, reminder2]),
  ],
);
```

### Widget Tests

```dart
testWidgets('SplashScreen shows loading indicator', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## Best Practices

### 1. DRY (Don't Repeat Yourself)
- Extract common logic to utilities
- Create reusable widgets
- Use extensions for repeated operations

### 2. SOLID Principles
- **S**ingle Responsibility - Each class one job
- **O**pen/Closed - Open for extension, closed for modification
- **L**iskov Substitution - Implementations replaceable
- **I**nterface Segregation - Many specific interfaces
- **D**ependency Inversion - Depend on abstractions, not concretes

### 3. Const Constructors
```dart
// ✅ Always use const for widgets when possible
const SizedBox(height: 16.0)

// ❌ Avoid unnecessary rebuilds
SizedBox(height: 16.0)
```

### 4. Equatable for value comparison
```dart
// ✅ Use Equatable to prevent unnecessary rebuilds
class Reminder extends Equatable {
  final String id;
  
  @override
  List<Object?> get props => [id];
}

// Now Reminder('1') == Reminder('1') returns true
```

## Common Patterns

### Repository Pattern
```dart
// Domain: Interface
abstract class UserRepository {
  Future<User?> getUser(String id);
  Future<void> createUser(User user);
}

// Data: Implementation
class UserRepositoryImpl implements UserRepository {
  final LocalDataSource _localDataSource;
  
  @override
  Future<User?> getUser(String id) async {
    final model = await _localDataSource.getUser(id);
    return model?.toDomain();
  }
}
```

### Model-Entity Conversion
```dart
// Data model with serialization
@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  
  // Convert to domain entity
  User toDomain() => User(id: id, name: name);
}
```

## Debugging Tips

1. **Enable Logging**
   ```dart
   logger.i('User loaded: $user');
   logger.e('Error occurred', error: e);
   ```

2. **BLoC Observer**
   ```dart
   Bloc.observer = MyBlocObserver();  // Logs all BLoC transitions
   ```

3. **Flutter DevTools**
   ```bash
   flutter pub global activate devtools
   devtools
   ```

4. **Check Database**
   ```bash
   adb shell
   sqlite3 /data/data/com.drinklion.drinklion/databases/app.db
   SELECT * FROM users;
   ```

---

**For questions about architecture, see [CONTRIBUTING.md](CONTRIBUTING.md) or open a GitHub issue.**

# DrinkLion - Development Setup

## Project Structure

```
drinklion/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── presentation/
│   │   ├── screens/                       # UI Screens
│   │   ├── blocs/                         # BLoC state management
│   │   └── widgets/                       # Reusable widgets
│   ├── domain/
│   │   ├── entities/                      # Domain models
│   │   └── repositories/                  # Abstract repository interfaces
│   ├── data/
│   │   ├── datasources/                   # Local/remote data access
│   │   ├── models/                        # Data models (with serialization)
│   │   └── database/                      # SQLite database setup
│   └── core/
│       ├── theme/                         # Material 3 theme
│       ├── config/                        # App configuration
│       ├── services/                      # Global services (service locator, notifications)
│       └── utils/                         # Utilities (logger, extensions)
├── test/
│   ├── domain/                            # Domain layer tests
│   └── data/                              # Data layer tests
├── assets/
│   ├── images/                            # App images
│   └── icons/                             # App icons
├── pubspec.yaml                           # Dependencies
└── analysis_options.yaml                  # Lint rules
```

## Getting Started

### 1. Setup Flutter
```bash
flutter --version
flutter doctor
```

### 2. Install Dependencies
```bash
cd drinklion
flutter pub get
```

### 3. Generate Code (mocks, serializers)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run App
```bash
flutter run
```

### 5. Run Tests
```bash
flutter test
flutter test --coverage
```

## Architecture Guidelines

### Clean Architecture Layers

1. **Presentation Layer** (UI)
   - Screens, Widgets, BLoCs
   - Handles user interaction
   - Emits events, listens to states

2. **Domain Layer** (Business Logic)
   - Entities (domain models)
   - Repository interfaces (abstract)
   - Use cases (future)

3. **Data Layer** (Data Access)
   - Models (with serialization)
   - Data sources (local, remote)
   - Repository implementations

4. **Core Layer** (Shared)
   - Theme, config, services, utilities
   - Used across all layers

### Dependency Flow

```
Presentation → Domain ← Data
       ↓
      Core (utilities, config, theme)
```

**Rule:** Never import upward (data → domain, etc.)

## Development Workflow

### When adding a new feature:

1. **Define Domain Layer**
   - Create entity in `domain/entities/`
   - Create repository interface in `domain/repositories/`

2. **Implement Data Layer**
   - Create model in `data/models/`
   - Implement repository in `data/repositories/`
   - Add database operations in `data/datasources/`

3. **Create Presentation Layer**
   - Create BLoC in `presentation/blocs/`
   - Create screen in `presentation/screens/`
   - Create widgets in `presentation/widgets/`

4. **Test**
   - Unit tests in `test/domain/` and `test/data/`
   - Widget tests in `test/presentation/`

### Example: Implement User Profile Feature

```
1. Domain:
   - domain/entities/entities.dart (UserProfile)
   - domain/repositories/repositories.dart (UserRepository)

2. Data:
   - data/models/user_model.dart
   - data/datasources/local_data_source.dart (CRUD)
   - data/repositories/user_repository_impl.dart

3. Presentation:
   - presentation/blocs/user_profile/user_profile_bloc.dart
   - presentation/blocs/user_profile/user_profile_event.dart
   - presentation/blocs/user_profile/user_profile_state.dart
   - presentation/screens/onboarding_screen.dart

4. Tests:
   - test/domain/services/schedule_service_test.dart
   - test/data/repositories/user_repository_impl_test.dart
```

## Code Style

- Use `final` for variables that won't change
- Use `const` for compile-time constants
- Follow Flutter naming conventions
- Extract widgets into separate files when >100 lines
- Use meaningful variable names
- Add documentation comments for public APIs

## Next Steps

1. **Database Models** - Create data models mirroring SQLite schema
2. **Repository Implementations** - Implement repository methods
3. **BLoCs** - Create state management for each feature
4. **Screens** - Build UI screens
5. **Testing** - Write unit & widget tests
6. **Polish** - Dark mode, accessibility, i18n

## Important Files Locations

- **Theme**: [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)
- **Config**: [lib/core/config/](lib/core/config/)
- **Database**: [lib/data/database/app_database.dart](lib/data/database/app_database.dart)
- **Entities**: [lib/domain/entities/entities.dart](lib/domain/entities/entities.dart)

## Documentation References

- Technical Architecture: `TECHNICAL_ARCHITECTURE_SPEC.md`
- Database Design: `DATABASE_DESIGN_SPEC.md`
- UI/UX Wireframes: `UI_UX_WIREFRAME_SPEC.md`
- Testing Strategy: `TEST_STRATEGY_QA_PLAN.md`
- PRD: `PRD_DrinkLion.md`

---

**Happy Coding! 🚀**

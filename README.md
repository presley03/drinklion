# DrinkLion 🦁💧

> A smart health reminder app for Indonesians to maintain healthy drinking and eating habits

[![Flutter Version](https://img.shields.io/badge/Flutter-3.41.2-blue)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.11.0-blue)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](#license)
[![Android API](https://img.shields.io/badge/Android%20API-35%2B-brightgreen)](https://www.android.com)

## 📱 Overview

DrinkLion is a personalized health reminder application designed for Indonesians. It helps users maintain healthy hydration and meal consumption habits with intelligent, customizable reminders while respecting preferences like quiet hours and fasting periods.

**Key Benefits:**
- 🔔 Smart reminders for water intake and meals
- 🕐 Fasting mode support with customizable windows
- 🔕 Quiet hours to respect sleep schedules
- 📊 Reminder history and tracking
- 💾 100% local storage - no cloud required

## ✨ Features

### Core Reminders
- **Smart Water Reminders** - Customizable frequency with smart scheduling
- **Meal Reminders** - Set for breakfast, lunch, dinner, snacks
- **Flexible Scheduling** - Create unique reminder patterns per day
- **Quiet Hours** - Auto-pause notifications during sleep (9pm-8am default)
- **Fasting Mode** - Special handling for intermittent fasting practitioners

### User Management
- **Multiple Profiles** - Support for family/shared device usage
- **Custom Settings** - Per-user notification preferences
- **Health Goals** - Track personal health targets
- **Preference Control** - Detailed notification behavior customization

### Tracking & Analytics
- **Reminder History** - View all completed & missed reminders
- **Statistics** - Track hydration and meal habit trends
- **Activity Log** - Timestamped reminder events

### Technical
- 🔊 Sound & Vibration customization
- 🌍 Timezone support for accurate scheduling
- 📲 Local notifications (no server required)
- 🎨 Material Design 3 UI

## 🏗️ Architecture

Clean Architecture with Clear Separation of Concerns:

```
lib/
├── core/                    # Shared utilities & configuration
│   ├── config/             # App enums & constants
│   ├── services/           # Singletons (notifications, user context)
│   ├── theme/              # Material Design 3 theming
│   └── utils/              # Logger & helpers
│
├── data/                    # Data layer - Local storage & repositories
│   ├── database/           # SQLite configuration
│   ├── datasources/        # Data access implementation
│   ├── models/             # Data models with JSON serialization
│   └── repositories/       # Repository implementations
│
├── domain/                  # Business logic layer
│   ├── entities/           # Domain models
│   └── repositories/       # Repository interfaces (contracts)
│
└── presentation/            # UI layer
    ├── bloc/               # BLoC state management (per feature)
    └── screens/            # Screens & widgets
```

### State Management: BLoC Pattern

Each feature uses dedicated BLoC:
- **UserProfileBloc** - User & onboarding
- **ReminderBloc** - Reminder operations
- **NotificationBloc** - Notification handling
- **SettingsBloc** - User preferences
- **FastingBloc** - Fasting mode logic
- **HistoryBloc** - History & analytics

## 📋 Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| Framework | Flutter | 3.41.2 |
| Language | Dart | 3.11.0 |
| State Mgmt | flutter_bloc | 8.1.6 |
| Database | sqflite | 2.4.2 |
| Notifications | flutter_local_notifications | 17.2.4 |
| Background Tasks | workmanager | 0.9.0 |
| DI/Service Locator | get_it | 7.7.0 |
| Logging | logger | 2.1.0 |

## 🚀 Getting Started

### Prerequisites
- **Flutter** 3.41.2+
- **Dart** 3.11.0+
- **Android SDK** API 35+
- **Xcode** 14+ (for iOS)

### Installation

1. **Clone Repository**
   ```bash
   git clone https://github.com/presley03/drinklion.git
   cd drinklion
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Code** (if needed)
   ```bash
   flutter pub run build_runner build
   ```

4. **Run App**
   ```bash
   # Android emulator
   flutter emulators --launch Pixel_4a
   flutter run -d emulator-5554
   
   # Or connected device
   flutter run
   ```

### Build Commands

```bash
# Clean build
flutter clean
flutter pub get

# Format code
dart format lib/

# Analyze
flutter analyze

# Release build
flutter build apk --release
flutter build appbundle --release
```

## 📦 Project Structure

```
drinklion/
├── lib/                    # Source code (described above)
├── android/                # Android native integration
├── ios/                    # iOS native integration
├── assets/                 # Images, icons, sounds
├── test/                   # Unit tests
├── pubspec.yaml           # Dependencies & metadata
├── analysis_options.yaml  # Lint rules
├── README.md              # This file
├── CHANGELOG.md           # Version history
├── LICENSE                # MIT License
├── PRIVACY_POLICY.md      # Privacy & data handling
├── TERMS_OF_SERVICE.md    # Terms of use
├── CODE_OF_CONDUCT.md     # Community guidelines
├── CONTRIBUTING.md        # Contribution guide
└── ARCHITECTURE.md        # Detailed architecture
```

## 🗄️ Database

### Tables

**users**
- id, name, age, gender, health_goals, is_active, created_at, updated_at

**user_settings**  
- id, user_id, quiet_hours_enabled, quiet_start, quiet_end, fasting_enabled, fasting_start, fasting_end

**notification_schedules**
- id, user_id, type (WATER/MEAL), frequency_minutes, next_reminder_time

**reminder_logs**
- id, user_id, reminder_type, is_completed, log_date, log_time

## 🎯 Use Cases

### Daily Hydration
1. User sets water reminder every 2 hours
2. Receives notifications at 9am, 11am, 1pm, 3pm, 5pm
3. Can log completed reminders
4. Views history anytime

### Intermittent Fasting
1. Enable fasting mode (14h-6h)
2. Meal reminders auto-pause during fasting
3. Water reminders continue (customizable)
4. Fasting window displayed on home

### Quiet Sleep Hours
1. Set quiet hours 9pm-6am
2. All notifications paused during this time
3. If reminder scheduled during quiet hours, deferred to after
4. Can override manually if needed

## 🏃 Development

### Add New Feature

1. **Domain Layer**
   - Create entity in `domain/entities/`
   - Create repository interface

2. **Data Layer**
   - Create model in `data/models/`
   - Implement repository 
   - Add DB operations in `data/datasources/`

3. **Presentation Layer**
   - Create BLoC with events & states
   - Create screen/widgets
   - Wire up with service locator

4. **Test**
   - Add unit tests in `test/`
   - Add widget tests if UI heavy

### Code Style

- Use `final` for immutable variables
- Use `const` for compile-time constants
- Follow Flutter conventions
- Extract widgets >100 lines to separate files
- Add doc comments for public APIs
- Use meaningful variable names

## 🔒 Privacy & Security

- ✅ **No analytics tracking** - We don't track you
- ✅ **Local only** - All data on your device
- ✅ **Offline** - Works without internet
- ✅ **No account** - No login required

See [PRIVACY_POLICY.md](PRIVACY_POLICY.md) for details.

## 📄 License

MIT License - see [LICENSE](LICENSE) file

**You can:** ✅ Use commercially, Modify, Distribute, Use privately  
**You must:** 📋 Include license notice, Document changes  
**You cannot:** ❌ Hold liable authors, Claim original authorship

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to submit PRs
- Code style guidelines
- Development setup
- Testing requirements

## 📞 Support

- **Issues** - Report bugs via GitHub Issues
- **Discussions** - Ask questions in Discussions
- **Security** - Email security concerns (never public issues)

## 🗺️ Roadmap

### v1.0 (Current) ✅
- ✅ Core reminder functionality
- ✅ Fasting mode
- ✅ Quiet hours
- ✅ Reminder history
- ✅ User profiles

### v1.1 (Planned)
- 📋 Social features
- 📋 Advanced analytics
- 📋 Custom sounds
- 📋 Family management

### v2.0 (Future)
- 📋 Wearable integration
- 📋 Cloud sync option
- 📋 AI personalization
- 📋 Multi-language

## 📚 Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Detailed architecture & patterns
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [PRIVACY_POLICY.md](PRIVACY_POLICY.md) - Privacy & data
- [TERMS_OF_SERVICE.md](TERMS_OF_SERVICE.md) - Terms of use
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) - Community guidelines

## ❤️ Made with Love

Built by Presley for Indonesian health enthusiasts  
Using Flutter, Dart, and Clean Architecture  

**Last Updated:** March 2026  
**Version:** 1.0.0

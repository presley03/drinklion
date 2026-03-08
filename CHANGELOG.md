# Changelog

All notable changes to DrinkLion will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.0] - 2026-03-08

### Added
- ✨ Initial release - DrinkLion MVP
- 🔔 Smart water and meal reminders
- 📅 Customizable reminder schedules
- 🕐 Quiet hours support (auto-pause reminders)
- 🕌 Fasting mode with customizable windows
- 👤 Multiple user profiles support
- 📊 Reminder history and completion tracking
- ⚙️ Comprehensive user settings
- 🎨 Material Design 3 UI with light/dark theme
- 🗄️ Local SQLite database
- 📱 Local notifications with sound & vibration
- 🌍 Timezone support
- 📲 Workmanager background task support
- 🎯 Onboarding flow (4 screens)
- 🏠 Home screen with reminders overview
- ⚙️ Settings screen for preferences
- 📈 History screen with analytics

### Technical Details
- Built with Flutter 3.41.2 & Dart 3.11.0
- Clean Architecture with BLoC pattern
- 6 specialized BLoCs for state management
- SQLite for local data persistence
- flutter_bloc for state management
- flutter_local_notifications for alerts
- workmanager for background tasks
- Service locator pattern with GetIt

### Android
- Minimum SDK: 35 (Google Play requirement)
- Target SDK: 36
- Java Version: 17
- Core library desugaring enabled

### Known Limitations
- Background task scheduling may require manual setup in some Android versions
- Notifications: WorkManager minimum interval is 15 minutes
- No cloud sync (all local storage)
- No multi-device synchronization

### Fixed
- Workmanager Kotlin compatibility with Flutter 3.41.2
- NetworkType enum compatibility in workmanager 0.9.0
- NotificationManager initialization timeout handling
- Import conflicts and type mismatches
- 23 linter warnings from code cleanup

---

## Release Notes

### Version Management

**Major.Minor.Patch** format:
- **Major (X.0.0)** - Breaking changes
- **Minor (1.X.0)** - New features (backward compatible)
- **Patch (1.0.X)** - Bug fixes only

### Future Releases

**Planned for v1.1:**
- Multi-language support (Indonesian, English)
- Export/import user data
- Statistics dashboard improvements
- Custom notification sounds
- Family/group management

**Planned for v2.0:**
- Wearable OS (Android Wear) integration
- Optional cloud backup
- AI-powered personalized reminders
- Social features
- Widget support

---

## Update Instructions

### Updating the App

1. **Check Current Version:** Settings → About
2. **Check for Updates:** Manual check in app store
3. **Auto-Update:** Enable in app store settings

### Backup Before Update

```bash
# Recommended: Backup your device before updating
Settings → Backup & restore → Backup my data
```

### Reporting Issues

Found a bug in a version? Report it:
1. Note the app version (Settings → About)
2. Describe the issue in detail
3. Include device info (Android version, model)
4. Open GitHub issue: https://github.com/presley03/drinklion/issues

---

## Archive

### Version 1.0.0
**Status:** 🟢 Current Release  
**Released:** March 8, 2026  
**Support:** Full support provided

---

**Note:** This changelog is maintained for all released versions. Internal development versions use git history.

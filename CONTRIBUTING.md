# Contributing to DrinkLion

First off, thank you for considering contributing to DrinkLion! It's people like you that make DrinkLion such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs 🐛

Before creating bug reports, check the issue list as you might find out that you don't need to create one. When you are creating a bug report, include as many details as possible:

- **Use a clear, descriptive title**
- **Describe the exact steps which reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed after following the steps**
- **Explain which behavior you expected to see instead and why**
- **Include device details:** Android version, DrinkLion version
- **Include logs:** Use `flutter logs` and attach relevant output

### Suggesting Enhancements 💡

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Use a clear, descriptive title**
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the steps**
- **Describe the current behavior and expected behavior**
- **Explain why this enhancement would be useful**

### Pull Requests 🔀

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Follow the [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- Include appropriate test cases
- Update documentation as needed
- End all files with a newline

## Development Setup

### Prerequisites
- Flutter 3.41.2+
- Dart 3.11.0+
- Android SDK (API 35+)
- Git

### Local Setup

```bash
# Clone the repo
git clone https://github.com/presley03/drinklion.git
cd drinklion

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Create a feature branch
git checkout -b feature/your-feature-name
```

### Project Structure

```
lib/
├── core/           # Shared utilities
├── data/           # Data access & models
├── domain/         # Business logic
└── presentation/   # UI & BLoCs
```

### Code Style Guide

**Dart Style Guide**
```dart
// ✅ GOOD
final userName = 'John';
final List<String> names = <String>['Alice', 'Bob'];

// ❌ BAD  
var userName = 'John';
List names = ['Alice']; // Missing type

// ✅ Meaningful names
Future<void> fetchUserData() async { }

// ❌ Unclear names
Future<void> getData() async { }
```

**Null Safety**
```dart
// ✅ GOOD - Clear nullability
String? getUserName() { }
String getUserName() { }  // Never null

// ❌ BAD - Late initialization
late String name;  // Avoid when possible
```

**Comments**
```dart
/// Documentation comment - always for public APIs
/// Describes what this function does

// Single line comment for internal notes

/* Multi-line comment for complex explanations
   spanning multiple lines */
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/domain/repositories/user_repository_test.dart

# Run tests matching pattern
flutter test --name="user"
```

**Test Guidelines:**
- Write tests for new features
- Achieve >80% code coverage for core logic
- Use descriptive test names: `test('should [expected behavior] when [condition]')`
- Mock external dependencies

### Building & Testing Locally

```bash
# Format code
dart format lib/ test/

# Analyze code
flutter analyze

# Clean build
flutter clean
flutter pub get

# Run on emulator
flutter emulators --launch Pixel_4a
flutter run -d emulator-5554

# Run tests
flutter test
```

## Git Workflow

### Branch Naming
```
feature/add-user-profile      # New feature
bugfix/fix-reminder-crash      # Bug fix
docs/update-readme             # Documentation
refactor/clean-notification    # Refactoring
```

### Commit Messages

```
Format: [TYPE] Subject - Brief description

Examples:
[feat] Add fasting mode support
[fix] Fix notification timing issue  
[docs] Update README with API details
[test] Add user profile tests
[refactor] Simplify BLoC logic
[chore] Update dependencies
```

### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/new-feature
   ```

2. **Make Changes**
   - Write clean, well-documented code
   - Add tests for new functionality
   - Update documentation

3. **Local Testing**
   ```bash
   flutter analyze
   dart format lib/
   flutter test
   flutter run
   ```

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "[feat] Add new feature"
   ```

5. **Push to Fork**
   ```bash
   git push origin feature/new-feature
   ```

6. **Create Pull Request**
   - Use descriptive title
   - Link related issues: "Closes #123"
   - Describe your changes
   - Attach screenshots if UI changes

7. **Code Review**
   - Address feedback
   - Update code as requested
   - Re-request review

8. **Merge**
   - Maintainer merges PR
   - Your contribution is published!

## Additional Notes

### Documentation
- Update README.md for user-facing changes
- Update CHANGELOG.md for release notes
- Add code comments for complex logic
- Keep docs synchronized with code

### Performance
- Avoid rebuilding widgets unnecessarily
- Use `const` constructors
- Monitor async operations
- Profile with Flutter DevTools

### Security
- Never commit sensitive data (keys, tokens)
- Use .gitignore properly
- Follow security best practices
- Report security issues privately

## Questions?

- 📖 Read [ARCHITECTURE.md](ARCHITECTURE.md)
- 💬 Open a GitHub Discussion
- 📧 Email: presley@dev.local

## Recognition

Contributors will be:
- Added to GitHub contributors list
- Mentioned in release notes (if requested)
- Credited in the app (for significant contributions)

---

**Thank you for contributing to DrinkLion! 🙏**

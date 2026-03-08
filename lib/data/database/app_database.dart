import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:drinklion/core/config/app_config.dart';

/// Manages SQLite database for DrinkLion
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  Database? _db;

  AppDatabase._internal();

  factory AppDatabase() {
    return _instance;
  }

  /// Get database instance
  Future<Database> getDatabase() async {
    _db ??= await _initDatabase();
    return _db!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConfig.dbFileName);

    return openDatabase(
      path,
      version: AppConfig.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');

    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gender TEXT NOT NULL CHECK(gender IN ('male', 'female')),
        age_range TEXT NOT NULL CHECK(age_range IN ('5-12', '13-18', '19-65', '65+')),
        health_conditions TEXT NOT NULL DEFAULT '[]',
        activity_level TEXT NOT NULL CHECK(activity_level IN ('low', 'medium', 'high')),
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(id)
      )
    ''');

    // Create reminders_log table
    await db.execute('''
      CREATE TABLE reminders_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        reminder_type TEXT NOT NULL CHECK(reminder_type IN ('drink', 'meal')),
        meal_type TEXT CHECK(meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', NULL)),
        scheduled_time DATETIME NOT NULL,
        is_completed BOOLEAN NOT NULL DEFAULT FALSE,
        completed_at DATETIME,
        quantity TEXT,
        skipped_reason TEXT,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        CHECK((is_completed = TRUE AND completed_at IS NOT NULL) OR (is_completed = FALSE AND completed_at IS NULL))
      )
    ''');

    // Create indexes for reminders_log
    await db.execute(
        'CREATE INDEX idx_reminders_scheduled_time ON reminders_log(scheduled_time)');
    await db.execute(
        'CREATE INDEX idx_reminders_user_completed ON reminders_log(user_id, is_completed)');
    await db.execute(
        'CREATE INDEX idx_reminders_user_type ON reminders_log(user_id, reminder_type)');
    await db.execute(
        'CREATE INDEX idx_reminders_user_created_date ON reminders_log(user_id, DATE(created_at))');

    // Create notifications_schedule table
    await db.execute('''
      CREATE TABLE notifications_schedule (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('drink', 'meal')),
        meal_type TEXT CHECK(meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', NULL)),
        time TEXT NOT NULL,
        is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
        is_fasting_mode BOOLEAN NOT NULL DEFAULT FALSE,
        title TEXT,
        body TEXT,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        UNIQUE(user_id, type, meal_type, time)
      )
    ''');

    // Create indexes for notifications_schedule
    await db.execute(
        'CREATE INDEX idx_notifications_enabled ON notifications_schedule(user_id, is_enabled)');
    await db.execute(
        'CREATE INDEX idx_notifications_fasting ON notifications_schedule(user_id, is_fasting_mode)');

    // Create user_settings table
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL UNIQUE,
        notification_sound BOOLEAN NOT NULL DEFAULT TRUE,
        vibration BOOLEAN NOT NULL DEFAULT TRUE,
        theme TEXT NOT NULL DEFAULT 'light' CHECK(theme IN ('light', 'dark', 'system')),
        language TEXT NOT NULL DEFAULT 'id' CHECK(language IN ('id', 'en')),
        font_size TEXT NOT NULL DEFAULT 'normal' CHECK(font_size IN ('normal', 'large', 'xl')),
        quiet_hours_start TIME,
        quiet_hours_end TIME,
        fasting_mode_enabled BOOLEAN NOT NULL DEFAULT FALSE,
        fasting_start_time TIME,
        fasting_end_time TIME,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create app_metadata table
    await db.execute('''
      CREATE TABLE app_metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Insert metadata
    await db.insert('app_metadata', {
      'key': 'db_version',
      'value': '1',
    });
    await db.insert('app_metadata', {
      'key': 'app_version',
      'value': AppConfig.version,
    });
  }

  /// Handle database upgrades during version changes
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // TODO: Implement migrations for future versions
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE users ADD COLUMN new_field TEXT');
    // }
  }

  /// Close database connection
  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}

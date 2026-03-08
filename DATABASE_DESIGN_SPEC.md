# Database Design Specification | DrinkLion
## Entity Relationship Diagram (ERD) + SQL Schema

**Version:** 1.0  
**Date:** 8 March 2026  
**Database:** SQLite (Local, Offline)  

---

## 1. Entity Relationship Diagram (ERD)

### Visual ERD

```
┌──────────────────────┐
│      users           │
├──────────────────────┤
│ id (PK)              │
│ gender               │◄─┐
│ age_range            │  │
│ health_conditions    │  │
│ activity_level       │  │
│ created_at           │  │
│ updated_at           │  │
└──────────────────────┘  │
          │               │
          │ 1:N           │
          ├─────────────────────────────────┐
          │                                 │
          │                         ┌────────────────────────┐
          │                         │ notifications_         │
          │                         │ schedule               │
          │                         ├────────────────────────┤
          │                         │ id (PK)                │
          │         (FK)            │ user_id                │
          ├──────────────────────────►type (drink/meal)      │
          │                         │ time                   │
          │                         │ is_enabled             │
          │                         │ is_fasting_mode        │
          │                         │ created_at             │
          │                         │ updated_at             │
          │                         └────────────────────────┘
          │
          │ 1:N
          │
          ├─────────────────────────────────┐
          │                                 │
┌─────────────────────────────────┐        │
│ reminders_log                   │        │
├─────────────────────────────────┤        │
│ id (PK)                         │        │
│ user_id (FK)                    │◄───────┘
│ reminder_type (drink/meal)      │
│ meal_type (breakfast/lunch/...) │
│ scheduled_time                  │
│ is_completed                    │
│ completed_at (nullable)         │
│ quantity                        │
│ skipped_reason (nullable)       │
│ created_at                      │
│ updated_at                      │
└─────────────────────────────────┘

┌──────────────────────────┐
│ user_settings            │
├──────────────────────────┤
│ id (PK)                  │
│ user_id (FK)             │
│ notification_sound       │
│ vibration                │
│ theme (light/dark)       │
│ language (id/en)         │
│ font_size                │
│ quiet_hours_start        │
│ quiet_hours_end          │
│ created_at               │
│ updated_at               │
└──────────────────────────┘
        ▲
        │
┌───────────────────┐
│     users         │
│   (same as above) │
└───────────────────┘
```

---

## 2. Detailed Table Schemas

### 2.1 Users Table

**Purpose:** Store user profile & health information

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  
  -- User profile
  gender TEXT NOT NULL CHECK(gender IN ('male', 'female')),
  age_range TEXT NOT NULL CHECK(age_range IN ('5-12', '13-18', '19-65', '65+')),
  
  -- Health conditions (JSON array: ["diabetes", "hypertension", "asam_urat"])
  health_conditions TEXT NOT NULL DEFAULT '[]',
  
  -- Activity level
  activity_level TEXT NOT NULL CHECK(activity_level IN ('low', 'medium', 'high')),
  
  -- Metadata
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Ensure single user (for MVP, single device)
  UNIQUE(id)
);
```

**Indexes:**
```sql
CREATE INDEX idx_users_created_at ON users(created_at);
```

**Sample Data:**
```sql
INSERT INTO users (gender, age_range, health_conditions, activity_level)
VALUES ('female', '35-65', '["hypertension", "diabetes"]', 'medium');
```

---

### 2.2 Reminders Log Table

**Purpose:** Track all reminder completions and history

```sql
CREATE TABLE reminders_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  
  -- Reminder type
  reminder_type TEXT NOT NULL CHECK(reminder_type IN ('drink', 'meal')),
  
  -- Meal type (only for meal reminders)
  meal_type TEXT CHECK(meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', NULL)),
  
  -- Scheduled time for this reminder
  scheduled_time DATETIME NOT NULL,
  
  -- Completion status
  is_completed BOOLEAN NOT NULL DEFAULT FALSE,
  completed_at DATETIME,
  
  -- Quantity logged (e.g., "1 gelas", "1 piring")
  quantity TEXT,
  
  -- Reason if skipped
  skipped_reason TEXT,
  
  -- Metadata
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  CHECK(
    (is_completed = TRUE AND completed_at IS NOT NULL) OR
    (is_completed = FALSE AND completed_at IS NULL)
  )
);
```

**Indexes (Critical for queries):**
```sql
-- For fetching today's reminders
CREATE INDEX idx_reminders_scheduled_time 
  ON reminders_log(scheduled_time);

-- For completion rate calculation
CREATE INDEX idx_reminders_user_completed 
  ON reminders_log(user_id, is_completed);

-- For history view filtering
CREATE INDEX idx_reminders_user_type 
  ON reminders_log(user_id, reminder_type);

-- For date-based queries
CREATE INDEX idx_reminders_user_created_date 
  ON reminders_log(user_id, DATE(created_at));
```

**Sample Data:**
```sql
-- Drink reminder - completed
INSERT INTO reminders_log 
(user_id, reminder_type, scheduled_time, is_completed, completed_at, quantity)
VALUES (1, 'drink', '2026-03-08 09:00:00', TRUE, '2026-03-08 09:05:00', '1 gelas');

-- Meal reminder - not completed
INSERT INTO reminders_log 
(user_id, reminder_type, meal_type, scheduled_time, is_completed)
VALUES (1, 'meal', 'lunch', '2026-03-08 12:00:00', FALSE);
```

---

### 2.3 Notifications Schedule Table

**Purpose:** Store scheduled notification times for user

```sql
CREATE TABLE notifications_schedule (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  
  -- Type of notification
  type TEXT NOT NULL CHECK(type IN ('drink', 'meal')),
  
  -- Meal type (for meal notifications)
  meal_type TEXT CHECK(meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', NULL)),
  
  -- Time of day (HH:MM format) when notification should trigger
  time TEXT NOT NULL,
  
  -- Whether this notification is active
  is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  
  -- Whether fasting mode is active (silent notifications)
  is_fasting_mode BOOLEAN NOT NULL DEFAULT FALSE,
  
  -- Notification title & body (pre-populated)
  title TEXT,
  body TEXT,
  
  -- Metadata
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  UNIQUE(user_id, type, meal_type, time)
);
```

**Indexes:**
```sql
CREATE INDEX idx_notifications_enabled 
  ON notifications_schedule(user_id, is_enabled);

CREATE INDEX idx_notifications_email 
  ON notifications_schedule(user_id, is_fasting_mode);
```

**Sample Data:**
```sql
-- Water reminders (4 per day for this user)
INSERT INTO notifications_schedule (user_id, type, time, title, body, is_enabled)
VALUES 
  (1, 'drink', '07:00', 'Saatnya Minum Air 💧', 'Minum 1 gelas air untuk tetap sehat', TRUE),
  (1, 'drink', '09:00', 'Saatnya Minum Air 💧', 'Minum 1 gelas air untuk tetap sehat', TRUE),
  (1, 'drink', '12:00', 'Saatnya Minum Air 💧', 'Minum 1 gelas air untuk tetap sehat', TRUE),
  (1, 'drink', '15:00', 'Saatnya Minum Air 💧', 'Minum 1 gelas air untuk tetap sehat', TRUE);

-- Meal reminders
INSERT INTO notifications_schedule (user_id, type, meal_type, time, title, body, is_enabled)
VALUES 
  (1, 'meal', 'breakfast', '07:30', 'Saatnya Sarapan 🍳', 'Sarapan sehat dengan nasi, sayur, lauk, dan buah', TRUE),
  (1, 'meal', 'lunch', '12:30', 'Saatnya Makan Siang 🍽️', 'Makan siang sehat dengan 1 piring makanan sehat', TRUE),
  (1, 'meal', 'dinner', '18:30', 'Saatnya Makan Malam 🌙', 'Makan malam ringan, 2-3 jam sebelum tidur', TRUE);
```

---

### 2.4 User Settings Table

**Purpose:** Store user preferences (theme, language, accessibility)

```sql
CREATE TABLE user_settings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  
  -- Notification preferences
  notification_sound BOOLEAN NOT NULL DEFAULT TRUE,
  vibration BOOLEAN NOT NULL DEFAULT TRUE,
  
  -- UI preferences
  theme TEXT NOT NULL DEFAULT 'light' CHECK(theme IN ('light', 'dark', 'system')),
  language TEXT NOT NULL DEFAULT 'id' CHECK(language IN ('id', 'en')),
  font_size TEXT NOT NULL DEFAULT 'normal' CHECK(font_size IN ('normal', 'large', 'xl')),
  
  -- Quiet hours (for do-not-disturb)
  quiet_hours_start TIME,           -- NULL means no quiet hours
  quiet_hours_end TIME,
  
  -- Fasting mode schedule
  fasting_mode_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  fasting_start_time TIME,          -- NULL means no fasting
  fasting_end_time TIME,
  
  -- Metadata
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**Sample Data:**
```sql
INSERT INTO user_settings (user_id, notification_sound, theme, language, font_size)
VALUES (1, TRUE, 'dark', 'id', 'large');
```

---

### 2.5 App Metadata Table (Optional)

**Purpose:** Store app-level metadata (version, last migration, etc.)

```sql
CREATE TABLE app_metadata (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

**Sample Data:**
```sql
INSERT INTO app_metadata (key, value) VALUES ('db_version', '1');
INSERT INTO app_metadata (key, value) VALUES ('app_version', '1.0.0');
INSERT INTO app_metadata (key, value) VALUES ('last_notification_sync', '2026-03-08 10:00:00');
```

---

## 3. Key Queries (Performance-Critical)

### 3.1 Get Today's Reminders

```sql
-- Get all reminders for today (for Home screen)
SELECT 
  r.id,
  r.reminder_type,
  r.meal_type,
  r.scheduled_time,
  r.is_completed,
  ns.title,
  ns.body,
  ns.is_enabled
FROM reminders_log r
LEFT JOIN notifications_schedule ns 
  ON r.user_id = ns.user_id 
  AND r.type = ns.type
  AND CASE 
    WHEN r.reminder_type = 'meal' THEN r.meal_type = ns.meal_type
    ELSE TRUE 
  END
WHERE r.user_id = ?
  AND DATE(r.scheduled_time) = DATE('now')
ORDER BY r.scheduled_time ASC;

-- Expected result: ~8-12 reminders for typical user
-- Execution time: < 50ms (with indexes)
```

### 3.2 Get Completion Rate (This Week)

```sql
-- Calculate weekly completion rate
SELECT 
  COUNT(CASE WHEN is_completed = TRUE THEN 1 END) as completed,
  COUNT(*) as total,
  ROUND(
    100.0 * COUNT(CASE WHEN is_completed = TRUE THEN 1 END) / COUNT(*), 
    2
  ) as completion_percentage
FROM reminders_log
WHERE user_id = ?
  AND DATE(scheduled_time) >= DATE('now', '-7 days')
  AND DATE(scheduled_time) <= DATE('now');

-- Expected result: ~56 reminders (8 daily * 7 days), 60% completed
-- Execution time: < 100ms
```

### 3.3 Get History by Date Range

```sql
-- Get reminders for a date range (for History view)
SELECT 
  DATE(scheduled_time) as date,
  reminder_type,
  COUNT(*) as total_reminders,
  COUNT(CASE WHEN is_completed = TRUE THEN 1 END) as completed_reminders,
  ROUND(
    100.0 * COUNT(CASE WHEN is_completed = TRUE THEN 1 END) / COUNT(*),
    2
  ) as daily_percentage
FROM reminders_log
WHERE user_id = ?
  AND DATE(scheduled_time) BETWEEN ? AND ?
GROUP BY DATE(scheduled_time), reminder_type
ORDER BY DATE(scheduled_time) DESC;

-- Pagination: LIMIT 30 OFFSET (page * 30)
-- Expected execution time: < 200ms
```

### 3.4 Get Next 3 Upcoming Reminders

```sql
-- For notification preview widget (future feature)
SELECT 
  id,
  reminder_type,
  meal_type,
  scheduled_time,
  ns.title,
  ns.body
FROM reminders_log r
LEFT JOIN notifications_schedule ns 
  ON r.user_id = ns.user_id 
  AND r.reminder_type = ns.type
WHERE r.user_id = ?
  AND scheduled_time > DATETIME('now')
  AND is_completed = FALSE
ORDER BY scheduled_time ASC
LIMIT 3;

-- Expected execution time: < 50ms
```

---

## 4. Migration Strategy

### 4.1 Database Versioning

```dart
const int DB_VERSION = 1;

// For future: track migrations
const migrations = {
  1: _migrationV1,
  2: _migrationV2,  // Future
};

void _migrationV1(Database db) async {
  // Create all tables for v1
  await db.execute('''CREATE TABLE users (...)''');
  await db.execute('''CREATE TABLE reminders_log (...)''');
  // ... etc
}

void _migrationV2(Database db) async {
  // Example: Add new column
  // ALTER TABLE notifications_schedule ADD COLUMN repeat_type TEXT;
}
```

### 4.2 Migration Execution (sqflite)

```dart
final database = openDatabase(
  'drinklion.db',
  version: DB_VERSION,
  onCreate: (Database db, int version) async {
    // Create all tables
    await _initializeDatabase(db);
  },
  onUpgrade: (Database db, int oldVersion, int newVersion) async {
    // Apply migrations: oldVersion -> newVersion
    for (int v = oldVersion; v < newVersion; v++) {
      await migrations[v + 1]?.call(db);
    }
  },
);
```

### 4.3 Rollback Strategy (Manual)

```dart
// For MVP: backup user data before major updates
Future<void> backupDatabase() async {
  final dbPath = await getDatabasesPath();
  final sourcePath = join(dbPath, 'drinklion.db');
  final backupPath = join(dbPath, 'drinklion_backup_${DateTime.now().toIso8601String()}.db');
  
  final sourceFile = File(sourcePath);
  await sourceFile.copy(backupPath);
  logger.i('Database backed up to: $backupPath');
}
```

---

## 5. Data Integrity & Constraints

### 5.1 Integrity Checks

```sql
-- All foreign keys must be valid
PRAGMA foreign_keys = ON;

-- Ensure no duplicate user profiles
ALTER TABLE users ADD CONSTRAINT single_user UNIQUE(id);

-- Ensure completion_at only set if completed
ALTER TABLE reminders_log ADD CHECK(
  (is_completed = TRUE AND completed_at IS NOT NULL) OR
  (is_completed = FALSE AND completed_at IS NULL)
);

-- Ensure meal_type only for meal reminders
ALTER TABLE reminders_log ADD CHECK(
  (reminder_type = 'meal' AND meal_type IS NOT NULL) OR
  (reminder_type = 'drink' AND meal_type IS NULL)
);
```

### 5.2 Referential Integrity

```sql
-- All reminders must belong to valid user
PRAGMA foreign_keys = ON;
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- When user deleted, cascade delete all related data
```

---

## 6. Backup & Recovery Strategy

### 6.1 Export Data (Local JSON)

```dart
// User can export reminders history to JSON file
Future<String> exportDataToJson(int userId) async {
  final user = await userRepository.getUserProfile(userId);
  final remindersLog = await reminderRepository.getRemindersLog(userId);
  
  final exportData = {
    'export_date': DateTime.now().toIso8601String(),
    'app_version': '1.0.0',
    'user': user.toJson(),
    'reminders': remindersLog.map((r) => r.toJson()).toList(),
  };
  
  return jsonEncode(exportData);
}
```

### 6.2 Import Data (Restore)

```dart
Future<void> importDataFromJson(String jsonString) async {
  final data = jsonDecode(jsonString);
  
  // Verify version compatibility
  if (data['app_version'] != '1.0.0') {
    throw Exception('Incompatible version');
  }
  
  // Insert user data
  await userRepository.saveUserProfile(UserModel.fromJson(data['user']));
  
  // Insert reminders
  for (final reminder in data['reminders']) {
    await reminderRepository.insertReminder(ReminderModel.fromJson(reminder));
  }
}
```

---

## 7. Performance Optimization Summary

| Operation | Query | Index Used | Expected Time |
|-----------|-------|-----------|----------------|
| Fetch today's reminders | SELECT * WHERE DATE(scheduled) = TODAY | idx_reminders_scheduled_time | < 50ms |
| Calculate completion rate | GROUP BY date, CALCULATE % | idx_reminders_user_type | < 100ms |
| Get 30-day history | SELECT * WHERE date BETWEEN | idx_reminders_user_created_date | < 150ms |
| Update reminder status | UPDATE WHERE id = ? | Primary key | < 10ms |
| Insert new reminder | INSERT | Auto-increment | < 5ms |

---

## 8. Database Size Estimation

### Typical User (3 months data)

```
Daily reminders: 8 (water) + 3 (meals) = 11 reminders/day
90 days × 11 = 990 reminders

Per reminder record: ~200 bytes
Total data: 990 × 200 = ~198 KB

User metadata: ~5 KB
Indexes: ~50 KB
Overhead: ~50 KB

TOTAL: ~300 KB per user (very efficient!)
```

Even with 100K users, centralized SQLite would be only ~30MB (if ever centralized).

---

## 9. SQL Complete Schema Script

Save as `lib/data/database/schema.sql`:

```sql
-- Enable foreign keys
PRAGMA foreign_keys = ON;

-- Users table
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  gender TEXT NOT NULL CHECK(gender IN ('male', 'female')),
  age_range TEXT NOT NULL CHECK(age_range IN ('5-12', '13-18', '19-65', '65+')),
  health_conditions TEXT NOT NULL DEFAULT '[]',
  activity_level TEXT NOT NULL CHECK(activity_level IN ('low', 'medium', 'high')),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(id)
);

-- Reminders log table
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
);

-- Indexes for reminders_log
CREATE INDEX idx_reminders_scheduled_time ON reminders_log(scheduled_time);
CREATE INDEX idx_reminders_user_completed ON reminders_log(user_id, is_completed);
CREATE INDEX idx_reminders_user_type ON reminders_log(user_id, reminder_type);
CREATE INDEX idx_reminders_user_created_date ON reminders_log(user_id, DATE(created_at));

-- Notifications schedule table
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
);

-- Indexes for notifications_schedule
CREATE INDEX idx_notifications_enabled ON notifications_schedule(user_id, is_enabled);
CREATE INDEX idx_notifications_fasting ON notifications_schedule(user_id, is_fasting_mode);

-- User settings table
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
);

-- App metadata table
CREATE TABLE app_metadata (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

---

**End of Database Design Specification**

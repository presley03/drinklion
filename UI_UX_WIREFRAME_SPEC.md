# UI/UX Wireframe & Design Specification | DrinkLion
## Screen Definitions, Component Library, Navigation Flow

**Version:** 1.0  
**Date:** 8 March 2026  
**Design System:** Material 3 (Flutter)  
**Target Devices:** Android 10+, iOS 14+ (Mobile First)  

---

## 1. Design System Overview

### 1.1 Color Palette

```
Primary: #F39C12 (Warm Orange - Lion color, friendly energy)
Secondary: #27AE60 (Green - Health, vitality)
Accent: #3498DB (Blue - Trust, calm)
Error: #E74C3C (Red - Errors, warnings)

Background Light: #FFFFFF (Pure white)
Background Dark: #1A1A1A (Near black)

Surface Light: #F8F9FA (Light gray)
Surface Dark: #2D2D2D (Dark gray)

Text Primary Light: #212121 (Dark gray)
Text Primary Dark: #FFFFFF (White)
Text Secondary Light: #757575 (Medium gray)
Text Secondary Dark: #BDBDBD (Light gray)

Success: #27AE60 (Completion checkmark)
Warning: #F39C12 (Warnings, notifications)
Info: #3498DB (Information)
```

### 1.2 Typography

```
Font Family: 
- iOS: San Francisco (system default)
- Android: Roboto (system default)
- Web: Google Fonts: Poppins (fallback to Roboto)

Heading 1 (H1): 28sp, Bold (700), Line height 1.4
Heading 2 (H2): 24sp, Bold (700), Line height 1.4
Heading 3 (H3): 20sp, SemiBold (600), Line height 1.4
Body Large (L): 16sp, Regular (400), Line height 1.5
Body Medium (M): 14sp, Regular (400), Line height 1.5
Body Small (S): 12sp, Regular (400), Line height 1.5
Label Large (L): 14sp, SemiBold (600)
Label Medium (M): 12sp, SemiBold (600)

Scaling: Respect system font size multiplier (1x, 1.15x, 1.3x for accessibility)
```

### 1.3 Spacing & Layout

```
8px grid system:
- xs: 4px (small gaps)
- sm: 8px (standard gap)
- md: 16px (content padding)
- lg: 24px (section spacing)
- xl: 32px (major sections)
- xxl: 48px (screen top/bottom)

Padding: 16px (md) for screen edges by default
Border Radius: 12px for cards, 8px for smaller elements, 4px for buttons
Elevation/Shadow: Material 3 defaults (1dp, 3dp, 6dp)
```

### 1.4 Components Standard

```
Button Heights: 48px (minimum touch target - Material spec)
Input Heights: 56px minimum
Icon Sizes: 24px (standard), 32px (large), 48px (icon buttons)
Card Corners: 12px rounded
Modal: Full-screen or 80% height with bottom sheet
Divider: 1px, #E0E0E0
Snackbar: 48px height, bottom-safe area
```

---

## 2. Navigation Architecture

### 2.1 App Navigation Flow

```
┌─────────────────────────────────────────────────┐
│              DRINKLION APP FLOW                 │
└─────────────────────────────────────────────────┘

App Start
    ↓
[Check if first launch?]
    ├─ YES → Go to Onboarding
    └─ NO  → Go to Home

┌─────────────────────────────────────────────┐
│          ONBOARDING STACK (Wizard)          │
├─────────────────────────────────────────────┤
│ Screen 1: Welcome + Gender Selection        │
│ Screen 2: Age Range Selection               │
│ Screen 3: Health Conditions Selection       │
│ Screen 4: Activity Level Selection          │
└─────────────────────────────────────────────┘
    ↓ [Complete]
    ↓
┌──────────────────────────────────────────────────┐
│              MAIN APP (Bottom NavBar)            │
├──────────────────────────────────────────────────┤
│ Tab 1: Home (Today's reminders)                 │
│ Tab 2: History (Weekly/Monthly analytics)       │
│ Tab 3: Settings (Preferences + Health info)     │
└──────────────────────────────────────────────────┘

FROM HOME:
  Reminder Card → Detail Screen (show full info)
  "Fasting Mode" button → Fasting Dialog
  
FROM HISTORY:
  Bar chart → Date detail view
  
FROM SETTINGS:
  "Health Conditions" → Health Info Modal
  "Notification Times" → Time Picker
  "About" → About Screen (with privacy policy)
```

### 2.2 Route Definition (Flutter)

```dart
class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String reminderDetail = '/reminder-detail';
  static const String healthInfo = '/health-info';
  static const String notification = '/notification';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case history:
        return MaterialPageRoute(builder: (_) => HistoryScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case reminderDetail:
        final reminderId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ReminderDetailScreen(reminderId: reminderId),
        );
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
```

---

## 3. Screen Specifications

### Screen 1: Splash Screen

**Purpose:** Brand introduction, check user session

```
┌─────────────────────────────┐
│        SPLASH SCREEN        │
├─────────────────────────────┤
│                             │
│                             │
│         🦁 Logo             │  ← Lion holding water glass (SVG)
│       (center, 120x120)     │
│                             │
│      "Drink Lion"           │  ← Heading 2, primary color
│      (Centered, 24sp)       │
│                             │
│   "Stay Healthy, Stay      │  ← Body Small, secondary text
│    Hydrated"               │
│                             │
│    [Loading indicator]     │  ← Linear progress bar
│   (Indeterminate)          │
│                             │
└─────────────────────────────┘

Duration: Show for 2 seconds minimum
After: Auto-navigate to onboarding or home based on user session check
```

**UI Components:**
- Logo image (asset)
- Text centered
- Linear progress bar (Material 3 style)

---

### Screen 2-5: Onboarding Wizard

**Purpose:** Setup user profile in 4 steps

```
┌─────────────────────────────────────────────────────────┐
│  ONBOARDING SCREEN 1: Gender Selection                 │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  <- Back  |  Step 1/4  |  Skip                         │
│                                                         │
│  "Pilih Jenis Kelamin"                                │  ← Heading 2
│  (Your health needs vary by gender)                   │  ← Caption
│                                                         │
│        ┌─────────────────────┐                         │
│        │   👩 Female         │                         │  ← Row 1 button (full width, 56px)
│        │  (Perempuan)        │                         │
│        └─────────────────────┘                         │
│               ↑ Highlighted on tap                    │
│                                                         │
│        ┌─────────────────────┐                         │
│        │   👨 Male           │                         │  ← Row 2 button
│        │  (Laki-laki)        │                         │
│        └─────────────────────┘                         │
│                                                         │
│  [Cancel] [Next →]                                    │  ← Bottom buttons
│                                                         │
└─────────────────────────────────────────────────────────┘

SCREEN 2: Age Range Selection
┌─────────────────────────────────────────────────────────┐
│  "Berapa Usia Anda?"                                   │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐                   │
│  │ 5-12 tahun   │  │ 13-18 tahun  │  ← 2-column grid │
│  │ (Anak)       │  │ (Remaja)     │                   │
│  └──────────────┘  └──────────────┘                   │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐                   │
│  │ 19-65 tahun  │  │ 65+ tahun    │                   │
│  │ (Dewasa)     │  │ (Lansia)     │                   │
│  └──────────────┘  └──────────────┘                   │
│                                                         │
├─────────────────────────────────────────────────────────┤
│  Progress bar: ████░░ (2/4 filled)                    │
└─────────────────────────────────────────────────────────┘

SCREEN 3: Health Conditions Selection
┌─────────────────────────────────────────────────────────┐
│  "Ada Kondisi Kesehatan Khusus?"                      │
│  (Atau pilih "Tidak ada" jika tidak ada)             │
│                                                         │
│  ☐ Diabetes                                           │
│  ☐ Hipertensi (Tekanan Darah Tinggi)                │
│  ☐ Asam Urat                                         │
│  ☐ Tidak ada                        ← Selected (checked)│
│                                                         │
│  📌 Note: Pilihan ini membantu mengatur jadwal yang  │
│     tepat. Bukan diagnosis medis.                      │
│                                                         │
└─────────────────────────────────────────────────────────┘

SCREEN 4: Activity Level Selection
┌─────────────────────────────────────────────────────────┐
│  "Seberapa Aktif Anda?"                               │
│                                                         │
│  ┌──────────────────────────────────────────────────┐ │
│  │  🛋️  Low - Mostly sitting/desk work            │ │ ← Card selected
│  │     (Sedentary)                                 │ │
│  └──────────────────────────────────────────────────┘ │
│                                                         │
│  ┌──────────────────────────────────────────────────┐ │
│  │  🚶 Medium - Light exercise 2-3x per week       │ │
│  │    (Moderately active)                          │ │
│  └──────────────────────────────────────────────────┘ │
│                                                         │
│  ┌──────────────────────────────────────────────────┐ │
│  │  💪 High - Heavy exercise or physical work      │ │
│  │    (Very active)                                │ │
│  └──────────────────────────────────────────────────┘ │
│                                                         │
│  [Cancel] [← Back] [Done ✓]                          │
└─────────────────────────────────────────────────────────┘
```

**Key Design Details:**
- Top header: Back button, Step indicator (1/4), Skip button
- Body: Question title + subtitle
- Selection controls: Buttons, radio buttons, checkboxes
- Bottom: Navigation buttons (Cancel, Next/Back, Done)
- Accessibility: Large text (Heading 2), clear button targets (48px+)

---

### Screen 6: Home Screen

**Purpose:** Display today's reminders, quick actions

```
┌─────────────────────────────────────────────────────┐
│          HOME SCREEN - Today's Reminders           │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Status Bar (time, battery, signal)                │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │  Good Morning, Presley! 👋                   │  ← Greeting
│  │  (12 reminders today)                        │  ← Summary
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  [🏥 Mode Puasa]                                  │  ← Fasting toggle
│  (If today is fasting day, show enabled)         │
│                                                     │
│  ╔═══════════════════════════════════════════════╗ │
│  ║ 🌅 TODAY'S REMINDERS                          ║ │  ← Expandable section
│  ╠═══════════════════════════════════════════════╣ │
│  ║ 07:00 AM ✓ Minum 1 gelas air    [Completed] ║ │  ← Completed (gray out)
│  ╠═══════════════════════════════════════════════╣ │
│  ║ 07:30 AM  Sarapan               [History]    ║ │
│  ║                                              ║ │
│  ║ 1 piring (nasi, sayur, lauk, buah) 🍳      ║ │
│  ║                                              ║ │
│  ║ [Saya sudah] [Snooze]                       ║ │  ← Action buttons
│  ╠═══════════════════════════════════════════════╣ │
│  ║ 09:00 AM  Minum 1 gelas air      [Upcoming] ║ │  ← Upcoming (highlighted)
│  ║ (dalam 45 menit)                            ║ │
│  ║                                              ║ │
│  ║ [Saya akan] [Snooze]                        ║ │
│  ╠═══════════════════════════════════════════════╣ │
│  ║ ... more reminders ...                       ║ │
│  ╚═══════════════════════════════════════════════╝ │
│                                                     │
│  🎉 Completion rate: 67% today                   │  ← Progress badge
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │ Tab 1: Home  │ Tab 2: History │ Tab 3: ...  │   │  ← Bottom NavBar
│  └─────────────────────────────────────────────┘   │
│                                                     │
└─────────────────────────────────────────────────────┘

REMINDER CARD DETAIL (Expandable):

┌─────────────────────────────────────┐
│ 09:00 AM                            │  ← Time (aligned left)
│                                     │
│ 💧 Minum 1 gelas air               │  ← Icon + Title
│                                     │
│ Minum air putih 250ml untuk         │  ← Description
│ menjaga kesehatan.                  │
│                                     │
│ Estimasi waktu: dalam 45 menit      │  ← Time until
│                                     │
│ [Saya sudah minum] [Snooze]         │  ← Action buttons
│  ↑ Primary button   ↑ Secondary     │
│                                     │
└─────────────────────────────────────┘

STATES OF REMINDER CARD:
1. Completed: Grayed out, ✓ checkmark, timestamp
2. Upcoming (≤1 hour): Highlighted, blue accent, countdown
3. Upcoming (>1 hour): Normal, white background
4. Overdue: Red accent highlight
5. Snoozed: "Snoozed until HH:MM" message
```

**Key Components:**
- Greeting header with emoji (contextual: Good Morning/Afternoon/Evening)
- Fasting mode quick toggle (if applicable)
- Reminder cards: Expandable, dismissible
- Action buttons: "Saya sudah" (I did it), "Snooze"
- Completion badge at bottom
- Bottom navigation bar

---

### Screen 7: History Screen

**Purpose:** View reminder completion trends, analytics

```
┌─────────────────────────────────────────────────┐
│            HISTORY & ANALYTICS                  │
├─────────────────────────────────────────────────┤
│                                                 │
│  [Weekly ▼] [Monthly] [All Time]               │  ← Time range tabs
│                                                 │
│  📊 WEEKLY COMPLETION RATE                      │  ← Chart header
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ % Completion                           100│   │
│  │              ┌────┐                      │   │
│  │         ┌────┤ 72%├────┐                 │   │  ← Bar/Line chart
│  │     ┌───┤ 65%│    │ 68%│───┐            │   │
│  │  ┌──┤59%│    │    │    │   │ 70%│      │   │
│  │  │  │   │    │    │    │   │    │       │   │
│  │  └──┴───┴────┴────┴────┴───┴────┴───┘   │   │
│  │  Mon Tue Wed Thu Fri Sat Sun             │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  Filters:  [All] [Drink] [Meals]              │  ← Filter chips
│                                                 │
│  📋 REMINDERS THIS WEEK:                       │
│                                                 │
│  Mon, 3 Mar  •  9/12 completed (75%)          │  ← Day summary
│  ┌─────────────────────────────────────────┐   │
│  │ ✓ 07:00 - Minum air (completed)        │   │
│  │ ✓ 09:00 - Minum air (completed)        │   │
│  │ ✗ 11:00 - Minum air (missed)           │   │
│  │ ✓ 12:30 - Makan siang (completed)      │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  Tue, 4 Mar  •  10/12 completed (83%)         │
│  ... (collapsed, tap to expand)                │
│                                                 │
│  [Download Report ↓]                          │  ← Export option
│                                                 │
└─────────────────────────────────────────────────┘

MONTHLY VIEW:

┌─────────────────────────────────────────────────┐
│  📅 MARCH 2026 - COMPLETION OVERVIEW           │
├─────────────────────────────────────────────────┤
│                                                 │
│  Total Reminders: 320                          │
│  Completed: 213 (67%)                          │
│  Missed: 107 (33%)                             │
│                                                 │
│  🥇 Best Day: Mar 15 - 95% (11/12)            │
│  📉 Lowest Day: Mar 8 - 48% (6/12)            │
│                                                 │
│  📊 TRENDING:                                  │
│  Drink water: 72% avg                          │
│  Meals: 62% avg                                │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Key Components:**
- Time range selector (Weekly, Monthly, All Time)
- Chart visualization (bar chart, line chart)
- Filter chips (All, Drink, Meals)
- Day summary with collapsed/expanded list
- Statistics cards
- Export button

---

### Screen 8: Settings Screen

**Purpose:** Customize preferences, view health info

```
┌──────────────────────────────────────────────────┐
│              SETTINGS                            │
├──────────────────────────────────────────────────┤
│                                                  │
│  🚪 USER PROFILE                                │
│  ├─ Profile: Female, 35-65 tahun               │
│  ├─ Health: Diabetes, Hypertension             │
│  └─ [Edit Profile]                             │  ← Navigate to edit screen
│                                                  │
│  🔔 NOTIFICATIONS                              │
│  ├─ Turn on notifications:  [Toggle: ON]       │
│  ├─ Sound:                  [Toggle: ON]        │
│  ├─ Vibration:              [Toggle: ON]        │
│  ├─ Quiet hours: 10:00 PM - 7:00 AM    [Edit]  │
│  ├─ Fasting mode in Ramadan:           [Toggle]│
│  └─ [Customize reminder times]                 │  ← Goes to time picker
│                                                  │
│  🎨 APPEARANCE                                 │
│  ├─ Theme: Dark [Light] [Dark] [Auto]          │
│  ├─ Font size: [Normal] [Large] [Extra Large]  │
│  └─ Language: [Bahasa Indonesia] [English]     │
│                                                  │
│  ℹ️ HEALTH INFORMATION                          │
│  └─ [View Health Tips for Your Condition]      │  ← Health info modal
│                                                  │
│  ⚠️ MEDICAL DISCLAIMER                         │
│  "DrinkLion adalah reminder saja, bukan       │
│   pengganti saran dokter."                     │
│  [Read full disclaimer]                        │
│                                                  │
│  💰 SUPPORT THE APP                            │
│  └─ [View Donation Options]                    │
│                                                  │
│  ℹ️ ABOUT                                      │
│  ├─ Version: 1.0.0                             │
│  ├─ Privacy Policy                             │
│  ├─ Terms of Service                           │
│  └─ Credits & Open Source Licenses             │
│                                                  │
│  ⚙️ ADVANCED                                   │
│  ├─ [Export data as JSON]                      │
│  ├─ [Import data from backup]                  │
│  ├─ [Clear all data]                           │
│  └─ [Debug info] (dev only)                    │
│                                                  │
└──────────────────────────────────────────────────┘
```

**Key Components:**
- Grouped sections
- Toggle switches for boolean settings
- Dropdown/picker for selections
- Linked actions [Edit], [View]
- Descriptive labels
- Visual hierarchy

---

### Screen 9: Health Conditions Modal

**Purpose:** Show health condition specifics & tips

```
┌──────────────────────────────────────────────────┐
│  🏥 HEALTH CONDITION INFORMATION                │
├──────────────────────────────────────────────────┤
│  [Close ×]                                       │
│                                                  │
│  📌 YOUR CONDITION: Diabetes                    │
│                                                  │
│  ⚠️ DISCLAIMER:                                 │
│  "This is for educational purposes only. Not  │
│   a medical diagnosis. Consult your doctor."   │
│                                                  │
│  📝 OVERVIEW:                                  │
│  Diabetes mellitus adalah kondisi di mana      │
│  tubuh tidak dapat mengatur kadar gula darah   │
│  dengan baik.                                   │
│                                                  │
│  💧 HYDRATION TIPS:                            │
│  • Minum 8-10 gelas air per hari untuk        │
│    menjaga hidrasi                             │
│  • Hindari minuman manis (soda, jus)          │
│  • Air putih adalah pilihan terbaik            │
│                                                  │
│  🍽️ NUTRITION TIPS:                           │
│  • Pilih karbohidrat kompleks (nasi merah)    │
│  • Tambahkan protein (ikan, ayam tanpa kulit)  │
│  • Banyak sayuran hijau dan berserat          │
│  • Hindari makanan berkadar gula tinggi        │
│                                                  │
│  📅 REMINDERS FOR YOU:                         │
│  ✓ Minum air dengan rutin (8x/hari)           │
│  ✓ Makan pada waktu konsisten                  │
│  ✓ Batasi makanan manis                        │
│  ✓ Periksa gula darah secara berkala           │
│                                                  │
│  👨‍⚕️ WHEN TO CONSULT A DOCTOR:                 │
│  • Gejala: haus berlebih, sering buang air    │
│  • Kadar gula darah tidak stabil               │
│  • Perubahan berat badan drastis               │
│                                                  │
│  [Learn more] [Close]                         │
│                                                  │
└──────────────────────────────────────────────────┘
```

---

### Screen 10: Fasting Mode Dialog

**Purpose:** Quick fasting mode toggle

```
┌──────────────────────────────────────────┐
│  Mode Puasa                              │
│  [×]                                     │
├──────────────────────────────────────────┤
│                                          │
│  Aktifkan Mode Puasa?                   │
│                                          │
│  Saat mode puasa aktif:                 │
│  • Notifikasi tetap terjadwal, tapi     │
│    tanpa suara atau getaran             │
│  • Anda bisa sesuaikan jam puasa        │
│                                          │
│  ┌─────────────────────────────────┐    │
│  │ Puasa hari ini saja             │    │  ← Option 1
│  │ (Mulai jam 12:00 AM hari ini)   │    │
│  └─────────────────────────────────┘    │
│                                          │
│  ┌─────────────────────────────────┐    │
│  │ Puasa hingga tanggal tertentu   │    │  ← Option 2
│  │ (Atur waktu custom)             │    │
│  └─────────────────────────────────┘    │
│     [Mulai: ] [Ambil: ]                │
│                                          │
│  ┌─────────────────────────────────┐    │
│  │ Atur jam puasa sendiri          │    │  ← Option 3
│  │                                 │    │
│  │ Dari: [05:00] Hingga: [19:00]  │    │
│  └─────────────────────────────────┘    │
│                                          │
│  [Batal] [Aktifkan]                     │
│                                          │
└──────────────────────────────────────────┘
```

---

### Screen 11: Donation Pop-up

**Purpose:** Support app development (non-intrusive)

```
┌────────────────────────────────────────────┐
│  ❤️ Dukung Development DrinkLion          │
│                                            │
│  Terima kasih sudah menggunakan app ini! │
│  Bantuan Anda membantu kami terus         │
│  improve dan develop fitur baru.          │
│                                            │
│  Pilih nominal donasi:                    │
│                                            │
│  ┌────────────────┐ ┌────────────────┐   │
│  │ Rp 10.000      │ │ Rp 15.000      │   │
│  │ ☕ Sekadar kopi │ │ 🍜 Segelas teh  │   │
│  └────────────────┘ └────────────────┘   │
│                                            │
│  ┌────────────────┐                       │
│  │ Rp 20.000      │                       │
│  │ 🍕 Makan ringan │                       │
│  └────────────────┘                       │
│                                            │
│  ┌────────────────────────────────────┐   │
│  │ Atau: Lihat opsi donasi lainnya   │   │
│  │ (GitHub Sponsors, Ko-fi, etc)     │   │
│  └────────────────────────────────────┘   │
│                                            │
│  [Nanti] [Donasi Sekarang]               │
│                                            │
└────────────────────────────────────────────┘
```

**Trigger Logic:**
- Show 1x per month (after 7 days of usage)
- Dismissible with single tap
- Non-blocking

---

## 4. Component Library

### Common Button Styles

```dart
// Primary Button (Primary action)
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange, // #F39C12
    fixedSize: Size.fromHeight(48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: Text('Saya sudah minum'),
);

// Secondary Button (Secondary action)
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.grey),
    fixedSize: Size.fromHeight(48),
  ),
  child: Text('Snooze'),
);

// Tertiary Button (Minimal)
TextButton(
  onPressed: () {},
  child: Text('Skip'),
);

// Icon Button
IconButton(
  icon: Icon(Icons.close),
  onPressed: () {},
  tooltip: 'Close',
);
```

### Reminder Card Widget

```dart
class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onComplete;
  final VoidCallback onSnooze;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time
            Text(reminder.scheduledTime, style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 8),
            
            // Title with icon
            Row(
              children: [
                Icon(reminder.icon, size: 24, color: Color(0xFFF39C12)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(reminder.title, style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            SizedBox(height: 8),
            
            // Description
            Text(reminder.description, style: Theme.of(context).textTheme.bodySmall),
            SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: onComplete, child: Text('Saya sudah'))),
                SizedBox(width: 12),
                Expanded(child: OutlinedButton(onPressed: onSnooze, child: Text('Snooze'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Chart Widget

```dart
class CompletionChart extends StatelessWidget {
  final List<CompletionData> data;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: BarChart(
        BarChartData(
          barGroups: data.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.percentage,
                  color: Color(0xFFF39C12),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
```

---

## 5. Accessibility Guidelines

### 5.1 Color Contrast

✅ **WCAG AA Compliant:**
- Primary text (dark) on light background: 7:1 ratio
- Secondary text on light background: 4.5:1 ratio
- Primary text (light) on dark background: 7:1 ratio

✅ **Font Sizing:**
- Minimum: 12sp for captions
- Standard: 14sp-16sp for body text
- Headings: 20sp+
- Scaling: Respect system multiplier (1x, 1.15x, 1.3x)

✅ **Touch Targets:**
- Minimum 48x48dp (Material spec)
- Button height: 48dp+
- Icon buttons: 48dp minimum

✅ **Screen Reader Support:**
```dart
Semantics(
  label: 'Minum 1 gelas air, dijadwalkan jam 9 pagi',
  enabled: true,
  button: true,
  onTap: () => completeReminder(),
  child: ReminderCard(...),
);
```

### 5.2 Dark Mode Support

```dart
// Use dynamic colors
Color getPrimaryColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Colors.orange[300]! : Colors.orange;
}

// Use Material 3 dynamic theming
ThemeData.light(useMaterial3: true).copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFFF39C12),
    brightness: Brightness.light,
  ),
);

ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFFF39C12),
    brightness: Brightness.dark,
  ),
);
```

### 5.3 Orientation Support

```dart
// Support both portrait and landscape
OrientationBuilder(
  builder: (context, orientation) {
    if (orientation == Orientation.portrait) {
      return PortraitLayout();
    } else {
      return LandscapeLayout();
    }
  },
);

// Landscape: Use tablet-optimized layout (2-column)
```

---

## 6. Responsive Design Breakpoints

```
Phone (320-599dp): Single column, full-width
Tablet (600-839dp): Master-detail split view
Desktop (840+dp): Multi-column layout (future)

Example: History chart
- Phone: Full width, scrollable
- Tablet: 50% width, side-by-side with legend
- Desktop: 60% chart, 40% statistics panel
```

---

## 7. Animation Guidelines

```dart
// Reminder completion animation
AnimatedBuilder(
  animation: _scaleAnimation,
  builder: (context, child) {
    return Transform.scale(scale: _scaleAnimation.value, child: child);
  },
  child: Icon(Icons.check_circle, color: Colors.green),
);

// Page transitions
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: animation.drive(Tween(begin: Offset(1, 0), end: Offset.zero)),
      child: child,
    );
  },
);

// Duration: 300-500ms for most animations
// Curve: Material standard curves (easeInOut, easeOut)
```

---

## 8. Localization Strings (i18n)

```json
{
  "en": {
    "greeting_morning": "Good Morning",
    "greeting_afternoon": "Good Afternoon",
    "greeting_evening": "Good Evening",
    "reminder.drink": "Drink {quantity} of water",
    "reminder.meal": "Time for {meal}",
    "button.completed": "I did it",
    "button.snooze": "Snooze",
    "fasting_mode.title": "Fasting Mode",
    "fasting_mode.subtitle": "Notifications will be silent during fasting period"
  },
  "id": {
    "greeting_morning": "Selamat Pagi",
    "greeting_afternoon": "Selamat Siang",
    "greeting_evening": "Selamat Malam",
    "reminder.drink": "Minum {quantity} air",
    "reminder.meal": "Saatnya makan {meal}",
    "button.completed": "Saya sudah",
    "button.snooze": "Ingatkan nanti",
    "fasting_mode.title": "Mode Puasa",
    "fasting_mode.subtitle": "Notifikasi akan senyap selama periode puasa"
  }
}
```

---

**End of UI/UX Wireframe Specification**

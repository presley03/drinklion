# Product Requirements Document | DrinkLion
## Health Reminder App untuk Pengguna Indonesia

**Version:** 1.0  
**Status:** Draft  
**Last Updated:** 8 March 2026  
**Target Release:** 2-3 bulan (MVP + Health Conditions)  
**Platform:** Android & iOS (Flutter)  

---

## 1. Executive Summary

### Problem Statement
Pengguna Indonesia, terutama yang sibuk, sering lupa minum air dan makan dengan pola yang sehat. Walaupun ada aplikasi reminder health lainnya, kebanyakan:
- Meminta input kompleks (kalori, jumlah air dalam ml)
- Tidak akrab dengan pola makan Indonesia ("piring sehat", "1 gelas")
- Tidak sensitif terhadap kondisi kesehatan lokal (Diabetes, Hipertensi, Asam Urat)
- Mengumpulkan data user (privacy concern)

### Proposed Solution
**DrinkLion** adalah aplikasi reminder kesehatan mobile yang:
1. **Sederhana**: User hanya pilih kategori (JK, Usia, Kesehatan) → jadwal otomatis
2. **Lokal**: Gunakan metrik familiar ("1 gelas ~250ml", "1 piring nasi")
3. **Privasi**: 100% offline, tidak ada server/analytics
4. **Inklusif**: Mendukung semua usia (anak-lansia) + kondisi kesehatan
5. **Fleksibel**: Mode puasa, customizable di notification

### Success Criteria (3-6 Bulan)
| Metrik | Target | Timeline |
|--------|--------|----------|
| **Total Downloads** | 500+ | Month 6 |
| **Daily Active Users (DAU)** | 100-150 | Month 6 |
| **30-Day Retention (D30)** | 20%+ | Month 3 |
| **Donasi/Volunteer Rate** | 2-5% | Ongoing |
| **Reminder Completion Rate** | 60%+ (estimated) | Month 3 |
| **App Rating** | 4.2+ stars | Ongoing |

---

## 2. User Experience & Functionality

### 2.1 User Personas

**Persona 1: Ibu Rumah Tangga Sibuk (35-50 tahun)**
- Pain Point: Lupa minum air karena sibuk ngurus keluarga
- Goal: Reminder sederhana, tidak ribet
- Tech Level: Android dasar
- Preference: Font besar, tombol jelas, UI tidak kompleks

**Persona 2: Anak Muda (18-30 tahun)**
- Pain Point: Pola makan tidak teratur, sering skip sarapan
- Goal: Reminder yang bisa dikustomisasi, support puasa
- Tech Level: Advanced
- Preference: Modern design, bisa matikan notifikasi

**Persona 3: Lansia (60+ tahun)**
- Pain Point: Kondisi kesehatan (hipertensi, diabetes), perlu monitoring
- Goal: Jadwal minum yang consider kesehatan
- Tech Level: Dasar
- Preference: Aksesibilitas (font besar, high contrast)

**Persona 4: Penderita Kondisi Kesehatan (Semua usia)**
- Pain Point: Tidak tahu pola minum/makan yang aman untuk kondisi mereka
- Goal: Reminder yang disesuaikan dengan kondisi
- Tech Level: Variable
- Preference: Ada disclaimer jelas, jadwal yang masuk akal

### 2.2 User Stories & Acceptance Criteria

#### **Story 1: Initial Setup (Segmentation)**
*As a* new user  
*I want to* quickly set my profile (JK, Usia, Kesehatan, Aktivitas)  
*So that* app memberi jadwal yang tepat tanpa input kompleks

**Acceptance Criteria:**
- ✓ Setup wizard selesai dalam 2 menit
- ✓ 4 pertanyaan sederhana: Jenis Kelamin, Usia (range), Kondisi Kesehatan (multi-select), Aktivitas (low/medium/high)
- ✓ Kalau user pilih kondisi kesehatan → tampilkan disclaimer medis
- ✓ Setelah setup, default jadwal sudah aktif & user bisa langsung gunakan
- ✓ Profile bisa di-edit kapan saja di Settings

---

#### **Story 2: Receive Reminders (Core Feature)**
*As a* user  
*I want to* receive push notifications untuk minum & makan  
*So that* saya tidak lupa dan maintain pola sehat

**Acceptance Criteria:**
- ✓ Notifikasi minum air: setiap X jam (sesuai kategori)
- ✓ Notifikasi makan: breakfast, lunch, dinner (timing fleksibel)
- ✓ Notifikasi bisa disable per tipe (muin/makan)
- ✓ Time range customizable: misal "jangan kebangunin before 7am"
- ✓ Sound + vibration default, bisa silent di settings
- ✓ Notifikasi clear dan actionable ("Waktunya minum 1 gelas air")

---

#### **Story 3: Log Reminder Completion**
*As a* user  
*I want to* tap "Done" atau "Remind Later" untuk tiap reminder  
*So that* app track progress & adjust if needed

**Acceptance Criteria:**
- ✓ Tap "I drank 1 glass" atau "I ate 1 plate" → logged dengan timestamp
- ✓ "Remind Later" → reschedule notifikasi 30 menit kemudian
- ✓ "Dismiss" → mark as done (untuk force-done)
- ✓ Daily summary: berapa reminder completed hari ini
- ✓ Weekly view: chart simple (bar/pie) show completion rate

---

#### **Story 4: Manage Health Conditions**
*As a* user with health condition  
*I want to* edit my health profile & see custom reminders  
*So that* jadwal drinking & eating aman untuk kondisi saya

**Acceptance Criteria:**
- ✓ Support conditions: Diabetes, Hipertensi, Asam Urat (+ normal)
- ✓ Kalau select kondisi → default jadwal adjusted (misal: asam urat → kurangi protein reminder)
- ✓ Disclaimer: "This is not medical advice. Consult your doctor before changes."
- ✓ Informasi condition-specific: misal "Diabetes: limit sugar intake, maintain hydration"
- ✓ User bisa override jadwal default di "Advanced Settings"

---

#### **Story 5: Puasa/Fasting Mode**
*As a* user who fasts (Ramadan, intermittent fasting, etc.)  
*I want to* quickly toggle notifications untuk periode tertentu  
*So that* app respectful dengan culture & personal practice

**Acceptance Criteria:**
- ✓ Button "Mode Puasa" di home screen
- ✓ 3 opsi:
  - "Matikan notifikasi hari ini" (button di quick action)
  - "Matikan untuk period X" (date range picker)
  - "Set fasting hours" (misal 5am-7pm, auto-quiet hours)
- ✓ Notifikasi dalam period fasting tetap ada but silent/no sound
- ✓ Clear visual indicator kalau fasting mode aktif

---

#### **Story 6: Donasi/Support App**
*As a* user who loves the app  
*I want to* donate untuk support development  
*So that* app terus improve & server costs covered

**Acceptance Criteria:**
- ✓ 3 tier donasi: Rp 10.000, Rp 15.000, Rp 20.000
- ✓ Pop-up donasi minimal: 1x per bulan only (after 7+ days usage)
- ✓ Bisa close pop-up dengan 1 tap (tidak intrusive)
- ✓ Terimakasih message & special badge untuk donor (optional)
- ✓ Direct payment ke GCash/Gopay/Dana (simple integration)
- ✓ Atau bisa via GitHub Sponsors / direct Ko-fi link

---

#### **Story 7: Settings & Customization**
*As a* user  
*I want to* customize notification times, sounds, language  
*So that* app adapt ke my preferences

**Acceptance Criteria:**
- ✓ Settings menu dengan opsi:
  - Notification times (breakfast, lunch, dinner, drinking schedule)
  - Sound & vibration toggle
  - Language: Indonesian (default), English
  - Theme: Light/Dark mode
  - Reminder frequency: "Every 2 hours" vs "Every 3 hours"
  - Font size: normal/large/extra large (accessibility)
- ✓ "Reset to default" button
- ✓ Settings auto-save

---

#### **Story 8: View History & Analytics**
*As a* user  
*I want to* see my reminder completion history  
*So that* I track my health routine progress

**Acceptance Criteria:**
- ✓ Daily view: berapa reminder completed today
- ✓ Weekly view: chart showing completion rate per day
- ✓ Monthly view: summary & trends
- ✓ Filter: by type (minum/makan) atau all
- ✓ Simple, not overwhelming
- ✓ No data sent anywhere (all local)

---

### 2.3 Non-Goals (v1)

**NOT in MVP:**
- ❌ Cloud sync / multi-device sync
- ❌ Social features (share progress, challenges)
- ❌ Detailed nutrition tracking (calorie counter)
- ❌ Recipe suggestions
- ❌ Integration dengan health apps (Google Fit, Apple Health) → v2 maybe
- ❌ AI-powered insights ("You usually skip breakfast")
- ❌ Video tutorials / educational content
- ❌ Login / authentication (unnecessary for offline app)

**Deferred to v1.1:**
- Additional health conditions (Obesity, Thyroid, etc.)
- Wearable integration
- Advanced analytics

---

## 3. Recommended Health Guidelines

### 3.1 Default Daily Schedules by Persona

#### **Normal Adult (Female, 18-65, No Health Condition, Medium Activity)**
| Tipe | Frequency | Example Times | Volume |
|------|-----------|---------------|--------|
| **Minum Air** | 8 times/day | 7am, 9am, 11am, 1pm, 3pm, 5pm, 7pm, 8pm | 1 gelas (250ml) |
| **Sarapan** | 1x | 7-8am | 1 piring (nasi, sayur, lauk, buah) |
| **Makan Siang** | 1x | 12-1pm | 1 piring |
| **Makan Malam** | 1x | 6-7pm | 1 piring |
| **Snack** | Optional | 10am, 3pm | Fruit / light snack |

#### **Diabetes (Adjusted)**
| Tipe | Frequency | Example Times | Notes |
|------|-----------|---------------|-------|
| **Minum Air** | 8 times/day | Sama | Encourage regular hydration |
| **Sarapan** | 1x | 7am (consistent) | Include high-fiber + protein |
| **Makan Siang** | 1x | 12pm (consistent) | Balanced carbs, avoid sugary |
| **Makan Malam** | 1x | 6pm (consistent) | Light, 2-3 hours before bed |
| **Snack** | Limited | 10am, 3pm | Sugar-free, high fiber |
| **Special** | Daily | Reminder to check blood sugar | |

#### **Hipertensi (High Blood Pressure)**
| Tipe | Frequency | Example Times | Notes |
|------|-----------|---------------|-------|
| **Minum Air** | 6-7 times/day | Sama | Maintain hydration (not excess) |
| **Sarapan** | 1x | 7am | Low sodium, high K+ (pisang, bayam) |
| **Makan Siang** | 1x | 12pm | Lean protein, minimal salt |
| **Makan Malam** | 1x | 6pm | Early, light |
| **Snack** | Limited | Fruits only | Avoid salty snacks |
| **Special** | Daily | Remind check blood pressure | |

#### **Asam Urat (Gout)**
| Tipe | Frequency | Example Times | Notes |
|------|-----------|---------------|-------|
| **Minum Air** | 10+ times/day | Higher frequency | Maintain alkaline urine |
| **Sarapan** | 1x | 7am | Avoid purine-rich (organ meat) |
| **Makan Siang** | 1x | 12pm | Plant-based preferred |
| **Makan Malam** | 1x | 6pm | Light, early |
| **Snack** | Limited | Low-purine only | Vegetables, almonds |
| **Special** | Daily | Increase water intake reminder | |

**Other Variants (same core principle):**
- **Anak (5-12 tahun)**: Frekuensi minum lebih sering, porsi lebih kecil (½ gelas), snack 2-3x
- **Lansia (65+)**: Frekuensi sama, reminder incontinence concern, early dinner
- **Low Activity**: Reduce minum frequency by 1-2 times, same meals
- **High Activity**: Increase minum frequency (+2-3), same meals but bigger portions

---

## 4. Technical Specifications

### 4.1 Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App (UI Layer)               │
│  ┌─────────────┐ ┌──────────────┐ ┌─────────────────┐  │
│  │   Home      │ │  Settings    │ │   History       │  │
│  │  Screen     │ │  Screen      │ │   Screen        │  │
│  └─────────────┘ └──────────────┘ └─────────────────┘  │
│  ┌─────────────────────────────────────────────────────┐│
│  │              Notification Manager                   ││
│  │  (Local Notifications via flutter_local_     ││
│  │   notifications plugin)                      ││
│  └─────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────┘
         │
         ↓
┌─────────────────────────────────────────────────────────┐
│         Business Logic Layer (BLoC/Provider)            │
│  ┌──────────────┐ ┌──────────────┐ ┌────────────────┐  │
│  │ User Profile │ │  Reminder    │ │   History      │  │
│  │ Repository   │ │  Repository  │ │   Repository   │  │
│  └──────────────┘ └──────────────┘ └────────────────┘  │
└─────────────────────────────────────────────────────────┘
         │
         ↓
┌─────────────────────────────────────────────────────────┐
│            Local Storage Layer (SQLite/Hive)            │
│  ┌────────────────────────────────────────────────────┐ │
│  │  users table                                       │ │
│  │  {id, gender, age, health_condition, activity}    │ │
│  │                                                    │ │
│  │  reminders_log table                              │ │
│  │  {id, type, scheduled_time, completed, timestamp} │ │
│  │                                                    │ │
│  │  settings table                                   │ │
│  │  {id, notification_enabled, sound, theme, ...}   │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
     (100% Offline, No Backend)
```

### 4.2 Database Schema

**Table: users**
```
id (PK)           : INTEGER
gender            : TEXT (male/female)
age_range         : TEXT (5-12, 13-18, 19-65, 65+)
health_conditions : TEXT (JSON array: ["diabetes", "hypertension", ...])
activity_level    : TEXT (low/medium/high)
created_at        : DATETIME
updated_at        : DATETIME
```

**Table: reminders_log**
```
id (PK)           : INTEGER
reminder_type     : TEXT (drink/meal)
meal_type         : TEXT (breakfast/lunch/dinner/snack) [if meal]
scheduled_time    : DATETIME
is_completed      : BOOLEAN
completed_at      : DATETIME (nullable)
quantity          : TEXT (1 glass, 1 plate, etc.)
created_at        : DATETIME
```

**Table: notifications_schedule**
```
id (PK)           : INTEGER
type              : TEXT (drink/meal)
time              : TIME (HH:MM)
is_enabled        : BOOLEAN
is_fasting_mode   : BOOLEAN
created_at        : DATETIME
```

**Table: user_settings**
```
id (PK)           : INTEGER
notification_sound : BOOLEAN
vibration          : BOOLEAN
theme              : TEXT (light/dark)
language           : TEXT (id/en)
font_size          : TEXT (normal/large/xl)
quiet_hours_start  : TIME
quiet_hours_end    : TIME
created_at         : DATETIME
```

### 4.3 Tech Stack

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| **Frontend Framework** | Flutter 3.x+ | Cross-platform (iOS/Android), fast dev, hot reload |
| **State Management** | BLoC / Provider | Scalable, testable, popular in Flutter ecosystem |
| **Local Database** | SQLite (sqflite) | Lightweight, offline-first, widely supported |
| **Notifications** | flutter_local_notifications + Workmanager | Reliable push, background scheduling |
| **UI Components** | Material 3 + Cupertino | Follow platform conventions, accessibility |
| **HTTP (if future)** | dio | For future cloud sync / analytics |
| **Payment** | flutter_stripe / paypal_sdk | (v1 placeholder for donasi) |
| **Localization** | easy_localization / intl | i18n support (Indonesian + English) |
| **Logging** | logger package | Debug & error tracking (local only) |
| **Testing** | Flutter test + mockito | Unit, widget, integration tests |

### 4.4 Key Features & Implementation Details

#### 4.4.1 Notification Scheduling
- Use **WorkManager** for Android background scheduling (reliable for 8+ reminders/day)
- Use **ios_background_modes** + APNS for iOS
- Store schedule in SQLite, regenerate on app start
- Handle snoozed reminders: reschedule via notification response

#### 4.4.2 Health Condition Logic
- Hardcoded schedules per condition (see Section 3.1)
- User select condition → load template → can customize
- Disclaimer modal on first setup if health condition selected

#### 4.4.3 Fasting Mode
- Toggle quick action → set "quiet hours" in database
- During quiet hours: notification scheduled but silent (no sound/vibration)
- User can manually snooze all for 1 day

#### 4.4.4 Donasi Integration
- Minimal pop-up: show after 7 days of usage, repeat monthly
- Payment gateway: direct link to GCash/Gopay/Dana invoice
- Or GitHub Sponsors embed (simple iframe if web view available)

#### 4.4.5 Accessibility
- Font scaling: use MediaQuery.textScaleFactor
- High contrast mode: supported via theme
- Readable colors: WCAG AA compliant
- Buttons: >48dp tap target (Material standard)

---

## 5. Integration Points & Dependencies

### 5.1 External APIs (Optional, Future)
- **Firebase Analytics** (v2): Optional usage tracking (with user consent)
- **Google Play Store**: App distribution
- **Apple App Store**: iOS distribution
- **Payment Gateway**: Xendit, Midtrans, or direct GCash/Gopay

### 5.2 Plugins & Dependencies

**Core:**
- `flutter_local_notifications: ^14.0.0`
- `workmanager: ^0.5.0`
- `sqflite: ^2.2.0`
- `provider: ^6.0.0` or `flutter_bloc: ^8.0.0`

**UI:**
- `google_fonts: ^5.0.0`
- `flutter_svg: ^2.0.0` (for lion logo)
- `intl: ^0.19.0`

**Notifications (Android specific):**
- `android_alarm_manager_plus: ^3.0.0` (Android 12+ WorkManager)

**Testing:**
- `flutter_test` (built-in)
- `mockito: ^5.0.0`
- `integration_test` (built-in)

---

## 6. Security & Privacy

### 6.1 Data Handling

✅ **Privacy-First Approach:**
- ✓ **No server/backend** → all data local device only
- ✓ **No user authentication** → no login needed
- ✓ **No analytics** → no tracking of behavior
- ✓ **No data collection** → no third-party SDKs
- ✓ **Encrypted local storage** (optional): use encrypted_shared_preferences for sensitive data

### 6.2 Sensitive Data Protection

| Data | Protection |
|------|-----------|
| User profile (gender, age, conditions) | SQLite local, optional encryption |
| Reminder logs | Local SQLite |
| Settings | SharedPreferences (unencrypted OK, no sensitive data) |
| Notification tokens | N/A (no backend) |

### 6.3 Compliance & Disclaimer

**Medical Disclaimer (Required):**
```
⚠️ MEDICAL DISCLAIMER
DrinkLion adalah aplikasi reminder kesehatan saja dan BUKAN pengganti 
saran medis profesional. Jadwal minum & makan yang diberikan berdasarkan 
panduan umum WHO/Kemenkes RI dan bukan disesuaikan untuk kondisi medis 
spesifik Anda.

SEBELUM menggunakan app ini, khususnya jika Anda memiliki kondisi medis 
seperti Diabetes, Hipertensi, atau penyakit lainnya, KONSULTASIKAN dengan 
dokter Anda terlebih dahulu.

DrinkLion tidak bertanggung jawab untuk:
- Diagnosa kondisi medis
- Komplikasi dari penggunaan app
- Accuracy jadwal untuk kondisi Anda

Gunakan aplikasi ini dengan bijak dan always consult healthcare provider.
```

**Privacy Policy (Simple):**
```
DrinkLion TIDAK mengumpulkan, menyimpan, atau membagikan data personal Anda.
Semua data disimpan lokal di perangkat Anda dan tidak pernah dikirim ke server.
```

### 6.4 Permissions (Android)
- `android.permission.POST_NOTIFICATIONS` (Android 13+) → push notifications
- `android.permission.SCHEDULE_EXACT_ALARM` (Android 12+) → precise scheduling
- `android.permission.RECEIVE_BOOT_COMPLETED` → reminders on device restart

---

## 7. Risks & Mitigation

### 7.1 Technical Risks

| Risk | Impact | Mitigation |
|------|--------|-----------|
| **Notification misfire on Android 12+** | Reminders don't deliver | Use WorkManager + AlarmManager dual approach, extensive testing |
| **App killed by OS** | No reminders next day | Implement "onCreate" restart service, handle boot_completed |
| **SQLite corruption** | Data loss | Regular backup, error handling, migrate on upgrade |
| **Screen-off notification delay** | Reminder late | Use full-screen intent (Android 11+) + sound/vibration |
| **iOS background limitation** | iOS reminders less frequent | Use newer background modes, silent notifications + BadgeCount |

### 7.2 Product Risks

| Risk | Likelihood | Mitigation |
|------|-----------|-----------|
| **Low adoption (< 500 DAU by M6)** | Medium | Focus on Indonesian community, beta testing, referral incentives |
| **High uninstall (low D30 retention)** | Medium | Gather user feedback early, improve UX via A/B testing, education on benefits |
| **Health condition misinformation** | Low (disclaimer present) | Always include medical disclaimer, review health data with expert |
| **App store rejection** | Low | Comply with Play Store / App Store health app policies, remove medical claims |

### 7.3 Monetization Risks

| Risk | Mitigation |
|------|-----------|
| **Low donation conversion** | Limit pop-up to 1x/month, provide value first (free features reliable) |
| **Payment platform down** | Provide multiple payment options (GCash, Gopay, Dana, PayPal) |
| **Subscription complexity** | Stick to one-time donations only (no recurring), simpler logic |

---

## 8. Phased Rollout & Roadmap

### 8.1 Phase 1: MVP (Month 1-2)

**Goal:** Core reminder functionality for 1-2 health condition personas

**Features:**
- ✓ User onboarding (profile setup in 2 min)
- ✓ 3 health conditions: Normal, Diabetes, Hipertensi
- ✓ Daily reminders: minum (8x) + makan (3 meals + optional snacks)
- ✓ Push notifications + completion logging
- ✓ Basic history/analytics (daily/weekly view)
- ✓ Settings: notification time, sound, language, font size
- ✓ Fasting mode (quick toggle)
- ✓ Minimal design, Indonesian language

**Deliverables:**
- Flutter app APK (beta)
- Firebase TestLab automated tests
- Beta testers: 50-100 users
- Medical disclaimer prominent

**Success Metric:**
- 0 crash rate in beta
- 70%+ beta users find setup <2 min
- D7 retention >30%

---

### 8.2 Phase 1.5: Launch (Month 2-2.5)

**Goal:** Soft launch on Play Store / TestFlight

**Features Refinement:**
- Asam Urat condition added
- Fix any notification bugs from beta
- Improve health condition descriptions

**Distribution:**
- Google Play Store (Indonesia region first)
- Apple App Store (if iOS ready)
- Community outreach: Reddit (/r/Indonesia), Facebook groups

**Target:**
- 500+ downloads by week 4
- 100+ DAU by week 4
- D30 retention 15-20%

---

### 8.3 Phase 2: Enhancement (Month 2.5-3)

**Goal:** Feature parity, improve retention

**Features:**
- Penyakit Jantung + Gagal Ginjal conditions added (per user request)
- Dark mode refinement
- Weekly summary notification
- Notification customization per meal
- Device language auto-detect

**Community:**
- Gather user feedback (in-app survey)
- Implement top 3 requests
- Optimize for low-end devices

**Target:**
- 1,000+ downloads
- 150-200 DAU
- D30 retention improved to 20-25%

---

### 8.4 Phase 3: Monetization & Polish (Month 3+)

**Goal:** Sustainable revenue, long-term retention

**Features:**
- Donasi pop-up (1x/month after 7 days)
- Payment integration (Xendit, Midtrans, GCash)
- "Donor" badge in app
- Advanced settings (custom reminder times per condition)
- Backup/restore (local export to JSON)

**Marketing:**
- Indonesian health blogs/influencer partnerships
- "Share your journey" campaign
- Monthly health tips newsletter (optional)

**Target:**
- 2-5% donor conversion
- 30-50 downloads/day organic
- D90 retention >15%

---

### 8.5 v1.1+ Future Roadmap (Post-Launch)

**v1.1 (Month 4-5):**
- Cloud sync (Firebase Firestore, privacy-respecting)
- Health app integration (Google Fit, Samsung Health read-only)
- Export data to CSV/PDF

**v2.0 (Month 6+):**
- Widget (home screen reminder status)
- Wearable support (Wear OS, Apple Watch)
- Advanced analytics (trend detection)
- Social features (optional: share progress with family)
- Nutrition info per condition (reference guide)

---

## 9. Success Metrics & KPIs

### 9.1 User Acquisition

| Metric | Target (Month 6) |
|--------|-----------------|
| Total Downloads | 500+ |
| Day 1 Installs (weekly avg) | 30-50 |
| Organic vs Paid | 80% / 20% |

### 9.2 Engagement

| Metric | Target (Month 3) |
|--------|-----------------|
| DAU | 100-150 |
| MAU | 200-250 |
| Reminder Sent/Day | 8+ (per active user) |
| Reminder Completion Rate | 60%+ |
| Session Length | 2-5 min |

### 9.3 Retention

| Metric | Target |
|--------|--------|
| D1 Retention | 50%+ |
| D7 Retention | 30%+ |
| D30 Retention | 20%+ |
| Churn Rate (weekly) | <10% |

### 9.4 Quality

| Metric | Target |
|--------|--------|
| Crash Rate | <0.1% |
| App Store Rating | 4.2+ stars |
| Negative Review %| <5% |
| Average Session Error Rate | 0% |

### 9.5 Monetization

| Metric | Target (Month 3-6) |
|--------|----------|
| Donor Rate | 2-5% |
| Avg Donation | Rp 15,000 |
| Monthly Revenue | Rp 100,000 - 500,000 |

---

## 10. Appendix: Reference & Regulatory

### 10.1 Indonesian Health Guidelines Referenced
- **Kemenkes RI**: Pola Piring Sehat (basic nutrition guidelines)
- **WHO**: Daily water intake recommendations
- **Diabetes Indonesia**: General diabetes management tips
- **Perhimpunan Dokter Hipertensi Indonesia (PDHI)**: Blood pressure management

### 10.2 Design Inspiration
- Logo: Cute lion head holding water glass (warm, friendly, not medical)
- Color Palette: Warm orange/amber (lion), clean white/light background, green accent (health)
- Typography: Indonesian-friendly, OpenSans or Poppins (modern yet readable)

### 10.3 Competitor Analysis (Brief)

| App | Strength | Weakness |
|-----|----------|----------|
| **Minum Air** | Local app, simple | Limited conditions, old design |
| **Google Fit** | Cloud sync, rich features | Requires account, complex setup |
| **MyFitnessPal** | Detailed tracking | Overwhelming, requires login, focuses on calories not schedule |
| **DrinkLion** (ours) | Offline, simple, health-aware, privacy | New, limited to reminders, no nutrition tracking |

---

## 11. Approval & Next Steps

### 11.1 Approval Sign-Off
- [ ] Product lead: Approved
- [ ] Tech lead: Approved
- [ ] Health advisor: Reviewed for medical accuracy (if applicable)
- [ ] Design lead: UI/UX approved

### 11.2 Next Steps
1. **Development Kickoff** (Month 1)
   - Set up Flutter project structure
   - Design database schema
   - Implement core reminder logic
   - Develop UI mockups

2. **Beta Testing** (Week 3-4 of Month 1)
   - Recruit 50-100 beta testers
   - Run crash analytics
   - Gather UX feedback

3. **Launch Preparation** (Month 2)
   - Finalize app store listings (screenshots, description)
   - Prepare privacy policy + medical disclaimer
   - Soft launch on Play Store

4. **Monitor & Iterate** (Month 2-3)
   - Track D7, D30 retention
   - Fix top reported bugs
   - Iterate on top 3 feature requests

---

## Document Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.5 | 8 March 2026 | AI Assistant | Initial discovery → PRD draft based on user requirements |
| 1.0 | 8 March 2026 | AI Assistant | Final PRD complete with all sections |

---

**End of Document**

# DrinkLion: Master Project Guide
## Complete Project Documentation Index & Quick Reference

**Version:** 1.0  
**Created:** 8 March 2026  
**Target Timeline:** 2-3 months (MVP to v1.1)  
**Solo Developer:** YES  

---

## 📚 Complete Documentation Set

### **1. PRD_DrinkLion.md** (Executive Blueprint)
**Status:** ✅ COMPLETE (11 sections, 50+ pages)

**Contains:**
- Executive summary + success metrics
- 4 user personas with pain points
- 8 detailed user stories with acceptance criteria
- Health guidelines for 4+ conditions (Diabetes, Hipertensi, Asam Urat, Normal)
- Technical overview & tech stack selection
- Phased rollout (Phase 1→3)
- Risk mitigation strategies
- Success KPIs for 3-6 months

**When to Use:**
- Onboarding new team member
- Stakeholder updates
- Feature planning
- Release retrospective

**Key Numbers:**
- Target: 500+ downloads + 100-150 DAU by M6
- 8+ daily reminders per user
- 20% D30 retention target
- 2-5% donation conversion

---

### **2. TECHNICAL_ARCHITECTURE_SPEC.md** (Deep Technical Design)
**Status:** ✅ COMPLETE (13 sections)

**Contains:**
- High-level system architecture diagram
- Presentation layer (Screens, BLoCs)
- Business logic layer (Repositories)
- Data layer (SQLite, local storage)
- Notification scheduling flows (Android WorkManager + iOS)
- Offline-first strategy
- Health condition logic & schedule generation algorithm
- Permission handling (Android 13+)
- Data flow examples (9 detailed flows)
- Error handling strategy per layer
- Performance optimization (DB queries, lazy loading)
- Environment configuration
- Dependency injection setup (GetIt)

**When to Use:**
- Before starting development
- When unsure how to implement a feature
- During code review
- Troubleshooting architecture issues

**Key Decisions:**
- **State Management:** BLoC (scalable, testable)
- **Local DB:** SQLite (lightweight, reliable)
- **Notifications:** WorkManager (Android) + iOS local notifications
- **Backend:** NONE for MVP (privacy-first)
- **Cloud Sync:** Deferred to v1.1

---

### **3. DATABASE_DESIGN_SPEC.md** (Data Modeling)
**Status:** ✅ COMPLETE (11 sections)

**Contains:**
- Entity Relationship Diagram (ERD) with visual
- 5 main tables:
  - `users` - profile data
  - `reminders_log` - completion history
  - `notifications_schedule` - scheduled reminders
  - `user_settings` - preferences
  - `app_metadata` - version tracking
- Detailed SQL schema with constraints
- Key performance queries (4 critical queries)
- Migration strategy & versioning
- Data integrity & referential integrity rules
- Backup & recovery strategy (JSON export)
- Complete SQL schema script (ready to use)
- Performance estimation (~300KB per user)

**When to Use:**
- Database initialization
- Query optimization
- Troubleshooting DB issues
- Migration planning

**Critical Details:**
- All 5 tables with UNIQUE constraints
- Indexes on `scheduled_time`, `user_completed`, `user_type`, `created_date`
- Foreign keys with CASCADE delete
- Estimated: 990 reminders/user in 90 days = 200KB

---

### **4. UI_UX_WIREFRAME_SPEC.md** (Design System & Screens)
**Status:** ✅ COMPLETE (11 sections)

**Contains:**
- Material 3 design system:
  - Color palette (Orange #F39C12 primary, Green accent)
  - Typography (Poppins/Roboto, 12-28sp range)
  - Spacing grid (8px multiples)
  - Component standards (48px buttons, 12px corners)
- Navigation architecture (onboarding → home tabs)
- 11 detailed screen specifications:
  1. Splash screen
  2-5. Onboarding wizard (4 steps)
  6. Home screen (today's reminders)
  7. History screen (analytics/charts)
  8. Settings screen (40+ options)
  9. Health info modal
  10. Fasting mode dialog
  11. Donation pop-up
- Component library (buttons, cards, charts)
- Accessibility guidelines (WCAG AA, font scaling, 48dp targets)
- Dark mode support
- Responsive design breakpoints (phone/tablet/desktop)
- Animation guidelines (300-500ms)
- i18n strings (Indonesian + English)

**When to Use:**
- UI development reference
- Design handoff to designer
- Accessibility audit
- Localization checklist

**Key Breakpoints:**
- Phone: 320-599dp (single column)
- Tablet: 600-839dp (2-column)
- Desktop: 840+dp (future)

---

### **5. TEST_STRATEGY_QA_PLAN.md** (Quality Assurance)
**Status:** ✅ COMPLETE (11 sections)

**Contains:**
- Test pyramid strategy (75% unit, 15% integration, 10% E2E)
- 80% code coverage target for business logic
- Unit test examples:
  - Schedule generation (4 test cases)
  - Completion rate calculation
  - BLoC state transitions
- Widget test examples:
  - Onboarding flow
  - Reminder completion
  - History chart rendering
  - Form validation
- Integration test scope (setup → reminder → completion)
- Manual testing checklist (40+ test cases across 6 areas)
- Device & OS compatibility matrix (Android 10-14, iOS 15+)
- Performance testing benchmarks:
  - Notification latency: <2s
  - Chart render: <500ms
  - Startup time: <3s
- GitHub Actions CI/CD pipeline (YAML provided)
- Bug severity levels & triage process
- Release gate criteria (P0/P1/P2 limits)
- Test environment setup
- Pre-release 7-day checklist

**When to Use:**
- Test planning
- PR/code review validation
- Release decision-making
- Performance debugging

**Coverage Target:**
- Unit: 80% (business logic)
- Widget: 60% (UI screens)
- Integration: Critical flows
- E2E: Manual on real devices

---

## 🗺️ How Documents Connect

```
                    PRD_DrinkLion.md
                    (What we're building)
                           ↓
            ┌──────────────┼──────────────┐
            ↓              ↓              ↓
      TECHNICAL_      DATABASE_       UI_UX_
      ARCHITECTURE    DESIGN          WIREFRAME
      (How it works)   (Data model)   (User interface)
            │              │             │
            └──────────────┼─────────────┘
                           ↓
                   TEST_STRATEGY_QA
                   (How we verify)
```

### Document Dependencies

```
START HERE:
  1. PRD_DrinkLion.md (read in 30 min)
     → Understand business goals & user stories

THEN CHOOSE PATH:

DEVELOPMENT PATH:
  2. TECHNICAL_ARCHITECTURE_SPEC.md
     → Learn system design before coding
  3. DATABASE_DESIGN_SPEC.md
     → Set up database schema
  4. UI_UX_WIREFRAME_SPEC.md
     → Reference during screen development

QA/TESTING PATH:
  2. TEST_STRATEGY_QA_PLAN.md
     → Write tests along with features
  3. DATABASE_DESIGN_SPEC.md
     → Test data layer queries
  4. TECHNICAL_ARCHITECTURE_SPEC.md
     → Test BLoC/business logic

DESIGN PATH:
  2. UI_UX_WIREFRAME_SPEC.md (focus here)
     → Create high-fidelity mockups
  3. TECHNICAL_ARCHITECTURE_SPEC.md (Section 2.1)
     → Understand screen components needed
```

---

## 🚀 Quick Start Checklist (Pre-Development)

### Week 1: Setup & Planning (3-5 days)

#### ✅ Day 1: Read Documentation
- [ ] Read PRD (sections 1-3) - 1 hour
- [ ] Read Architecture (sections 1-3) - 1 hour
- [ ] Read UI/UX (sections 1-3) - 45 min
- [ ] Review DB schema visual - 15 min
- **Total: 3 hours**

#### ✅ Day 2-3: Setup Project
- [ ] Create Flutter project: `flutter create drinklion`
- [ ] Add dependencies (see TECHNICAL_ARCHITECTURE section 4.3):
  ```bash
  flutter pub add flutter_bloc provider sqflite
  flutter pub add flutter_local_notifications workmanager
  flutter pub add google_fonts intl
  ```
- [ ] Setup folder structure:
  ```
  lib/
  ├── presentation/
  │   ├── screens/
  │   ├── blocs/
  │   └── widgets/
  ├── domain/
  │   ├── entities/
  │   ├── repositories/
  │   └── usecases/
  ├── data/
  │   ├── datasources/
  │   ├── models/
  │   └── database/
  └── main.dart
  ```
- [ ] Create SQLite schema (copy from DATABASE_DESIGN_SPEC.md, section 9)
- [ ] Setup logging & error handling

#### ✅ Day 4: Database & Models
- [ ] Implement SQLite initialization (AppDatabase class)
- [ ] Create all model classes (UserModel, ReminderModel, etc.)
- [ ] Test database creation & queries
- [ ] Implement data exporters (JSON backup)

#### ✅ Day 5: Architecture Foundation
- [ ] Setup service locator (GetIt)
- [ ] Create repository interfaces
- [ ] Implement LocalDataSource
- [ ] Create first BLoC (UserProfileBloc)

---

### Week 2-3: Core Features (14 days)

**Sprint 1 (Days 6-10): Onboarding + Home**
- [ ] Implement OnboardingScreen + wizard
- [ ] Implement UserProfileBloc
- [ ] Schedule generation algorithm (see TECHNICAL_ARCHITECTURE, Section 5.2)
- [ ] Implement HomeScreen
- [ ] Basic notification scheduling (manual testing)
- **Deliverable:** User can setup profile + see today's reminders

**Sprint 2 (Days 11-15): Notifications**
- [ ] Integrate WorkManager (Android)
- [ ] Implement NotificationBloc
- [ ] Test notification delivery (Android 12+, iOS)
- [ ] Implement reminder completion logging
- [ ] Implement History screen (basic)
- **Deliverable:** Notifications work, reminders tracked

---

### Week 4+: Polish & Testing (14+ days)

**Sprint 3 (Days 16-20): Features**
- [ ] Settings screen (full implementation)
- [ ] Fasting mode logic
- [ ] Health condition display
- [ ] UI refinements (dark mode, accessibility)
- [ ] Localization (i18n)

**Sprint 4 (Days 21-25): Testing & QA**
- [ ] Unit tests (business logic, 80% coverage)
- [ ] Widget tests (critical screens)
- [ ] Integration tests (end-to-end flows)
- [ ] Manual testing (3+ devices)
- [ ] Performance profiling

**Sprint 5 (Days 26+): Beta & Release**
- [ ] Beta build & Play Store submission
- [ ] Gather feedback from testers
- [ ] Fix critical bugs
- [ ] Release v1.0 to production

---

## 📊 Success Metrics Tracker

### Track These Weekly

| Metric | Target | Week 1 | Week 4 | Week 8 | Week 12 |
|--------|--------|--------|--------|--------|----------|
| Downloads | 500+ | N/A | 0 | 50-100 | 500+ |
| DAU | 100-150 | N/A | 0 | 20-30 | 100+ |
| D7 Retention | 30%+ | N/A | N/A | 25% | 30%+ |
| D30 Retention | 20%+ | N/A | N/A | N/A | 20%+ |
| Code Coverage | 80% | 40% | 60% | 75% | 80%+ |
| Crashes | <0.5% | N/A | <2% | <1% | <0.5% |
| Rating | 4.2+ | N/A | 3.8 | 4.0 | 4.2+ |

---

## 🔧 Common Development Scenarios

### "How do I implement schedule generation?"
→ Read: TECHNICAL_ARCHITECTURE.md **Section 5.2** (SchedulePersonalizer)

### "What tables do I need to create?"
→ Read: DATABASE_DESIGN_SPEC.md **Section 9** (SQL schema script)

### "What should I test for notification delivery?"
→ Read: TEST_STRATEGY_QA_PLAN.md **Section 5.2** (Manual checklist)

### "How should I handle dark mode?"
→ Read: UI_UX_WIREFRAME_SPEC.md **Section 5.2** (Dark mode support)

### "I need to fix a permission issue on Android 13+"
→ Read: TECHNICAL_ARCHITECTURE.md **Section 6.1** (AndroidManifest permissions)

### "How do I calculate completion rate?"
→ Read: DATABASE_DESIGN_SPEC.md **Section 3.2** (Query example)

### "What's the onboarding flow?"
→ Read: UI_UX_WIREFRAME_SPEC.md **Screens 2-5** (4-step wizard)

---

## 📝 Development Workflow

### Before Coding a Feature

1. **Read User Story** from PRD (Section 2 has 8 stories)
2. **Find Technical Details** in appropriate spec:
   - Logic → TECHNICAL_ARCHITECTURE
   - Data → DATABASE_DESIGN
   - UI → UI_UX_WIREFRAME
3. **Write Tests First** (TDD) per TEST_STRATEGY (Section 2-3)
4. **Implement Feature** referencing the spec
5. **Manual Test** using QA checklist (TEST_STRATEGY Section 5)

### Commit Message Format

```
[Feature/Fix/Refactor] Brief description

Story: US-{number} (if applicable)
Refs: PRD Section {X} / ARCH Section {X}
Tests: Added {N} unit tests
Checklist: ✓ Tests passing, ✓ Code reviewed, ✓ Perf OK
```

Example:
```
[Feature] Implement schedule generation algorithm

Story: US-1 (Setup Wizard)
Refs: TECHNICAL_ARCHITECTURE Section 5.2
Tests: Added 4 unit tests for schedule generation
Checklist: ✓ All tests passing (90% coverage), ✓ Reviewed, ✓ Performance OK (<100ms)
```

---

## 🎯 Phase Roadmap

### Phase 1: MVP (Month 1-2)
**Scope:** Core reminder functionality

From PRD Section 8.1:
- ✅ User onboarding (profile setup in 2 min)
- ✅ 3 conditions: Normal, Diabetes, Hipertensi
- ✅ Daily reminders: minum (8x) + makan (3x)
- ✅ Push notifications + completion logging
- ✅ Basic history/analytics
- ✅ Settings: notification time, sound, language, font size
- ✅ Fasting mode (quick toggle)

**Target:** 0 crashes, 70%+ setup <2min, D7 retention >30%

**Deliverable:** Beta APK on Play Store

---

### Phase 2: Enhancement (Month 2.5-3)
**Scope:** Feature parity + retention improvement

From PRD Section 8.2-8.3:
- ✅ Asam Urat + expand to 4 conditions
- ✅ Dark mode refinement
- ✅ Weekly summary notifications
- ✅ Notification customization per meal
- ✅ Device language auto-detect
- ✅ Gather feedback & iterate

**Target:** 1,000+ downloads, 150-200 DAU, D30 retention >20%

---

### Phase 3: Monetization (Month 3+)
**Scope:** Sustainable revenue + polish

From PRD Section 8.3-8.4:
- ✅ Donasi pop-up (1x/month after 7 days)
- ✅ Payment integration (Xendit/Midtrans)
- ✅ "Donor" badge in app
- ✅ Advanced settings
- ✅ Backup/restore feature

**Target:** 30-50 downloads/day organic, D90 retention >15%

---

## 🐛 Known Risks & Mitigation

| Risk | Severity | Mitigation | Document |
|------|----------|-----------|----------|
| Notification misfire on Android 12+ | HIGH | Use WorkManager + AlarmManager dual | TECHNICAL, 7.1 |
| User profile data loss | HIGH | Automatic SQLite backup | DATABASE, 6 |
| Low D30 retention | HIGH | Early gameplay loop, retention features | PRD, 7.2 |
| Play Store rejection | MEDIUM | Comply with policy early | TEST_STRATEGY, 8 |
| Performance: chart slow | MEDIUM | Pagination + lazy loading | TECHNICAL, 9.2 |

---

## 📞 Quick Reference Commands

```bash
# Project setup
flutter create drinklion
cd drinklion
flutter pub get

# Database setup
# Copy schema from DATABASE_DESIGN_SPEC.md Section 9
# Add sqlflite migrations

# Generate mocks
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test                              # All tests
flutter test --coverage                   # With coverage report
flutter test test/domain/services/       # Specific folder
flutter test --test-randomize-ordering-seed random  # Randomized

# Build
flutter build apk --release              # Android APK
flutter build appbundle                  # Android App Bundle
flutter build ios --release              # iOS (requires Mac)

# Run on device
flutter run
flutter run -d pixel_5                   # Specific device

# Performance profiling
dart devtools                             # Open DevTools
flutter run -d pixel_5 --profile         # Run in profile mode

# Firebase Testlab
firebase test android run --type instrumentation --app build/app/outputs/apk/release/app-release.apk
```

---

## 📞 Contact & Support

**Documentation Author:** AI Assistant (GitHub Copilot)  
**Last Updated:** 8 March 2026  
**Project Owner:** [Your Name]  

**Questions About:**
- **PRD:** Refer to PRD_DrinkLion.md or Section {X}
- **Architecture:** Refer to TECHNICAL_ARCHITECTURE_SPEC.md
- **Database:** Refer to DATABASE_DESIGN_SPEC.md
- **UI/Design:** Refer to UI_UX_WIREFRAME_SPEC.md
- **Testing:** Refer to TEST_STRATEGY_QA_PLAN.md

---

## 📋 Document Checklist (Before Dev Starts)

- [ ] Read PRD (all sections)
- [ ] Read Technical Architecture (sections 1-4)
- [ ] Review Database schema (sections 1-3)
- [ ] Review UI/UX (sections 1-4)
- [ ] Review Test Strategy (section 2)
- [ ] Ask questions about unclear sections
- [ ] Get sign-off from stakeholders
- [ ] Create GitHub issues from user stories (PRD Section 2)
- [ ] Setup CI/CD (TEST_STRATEGY Section 6.1)
- [ ] Start development on Day 1 of Week 2

---

**🎉 You're ready to build DrinkLion!**

**Next Step:** Begin Week 1 checklist with "Read Documentation" task.

**Estimated Development Time:** 60-80 hours for solo developer to MVP  
**Timeline:** 2-3 months total (MVP to v1.1)

**Good luck! 🚀**

# 📋 Schedule Generation Examples

This document demonstrates how the `ScheduleGenerationService` generates different reminder schedules based on user profiles.

## Example 1: Adult with No Health Conditions

**Profile**:
- Age: 19-65 (Adult)
- Activity: Medium
- Health Conditions: None
- Gender: Male

**Generated Schedule** (10 water reminders + 4 meals):
```
07:00 - Breakfast
07:36 - Water glass 1
08:12 - Water glass 2
08:48 - Water glass 3
09:24 - Water glass 4
12:00 - Lunch
13:20 - Water glass 5
13:56 - Water glass 6
14:32 - Water glass 7
15:00 - Snack
15:08 - Water glass 8
16:44 - Water glass 9
18:30 - Dinner
20:00 - Water glass 10
```

**Total**: 14 reminders

---

## Example 2: Senior (65+) with Hypertension

**Profile**:
- Age: 65+ (Senior)
- Activity: Low
- Health Conditions: Hypertension
- Gender: Female

**Generated Schedule** (7 reminders due to hypertension reduction + 4 meals + 1 BP check):
```
06:30 - Breakfast
07:30 - Blood pressure check
08:40 - Water glass 1
10:20 - Water glass 2
11:30 - Lunch
12:50 - Water glass 3
14:10 - Water glass 4
15:00 - Snack
16:30 - Water glass 5
17:50 - Water glass 6
17:30 - Dinner (early)
19:10 - Water glass 7
```

**Total**: 13 reminders (adjusted base + health condition notes)

**Notes**:
- Earlier meal times (Lansia preference)
- Base reminders reduced to 6-8 due to hypertension (fluid restriction)
- Morning BP check added
- Activity level LOW reduced count by 20%

---

## Example 3: Child (5-12) with Asam Urat

**Profile**:
- Age: 5-12 (Child)
- Activity: High
- Health Conditions: Asam Urat
- Gender: Male

**Generated Schedule** (15 water reminders + 5 meals):
```
07:00 - Breakfast
07:20 - Water glass 1
07:40 - Water glass 2
08:00 - Water glass 3
08:20 - Water glass 4
09:00 - Snack 1
09:40 - Water glass 5
10:00 - Water glass 6
10:20 - Water glass 7
10:40 - Water glass 8
12:00 - Lunch
12:40 - Water glass 9
13:00 - Water glass 10
13:20 - Water glass 11
13:40 - Water glass 12
14:00 - Water glass 13
15:00 - Snack 2
15:40 - Water glass 14
16:20 - Water glass 15
18:00 - Dinner
20:00 - Asamurat: Tingkatkan intake air
```

**Total**: 21 reminders

**Notes**:
- Base children: 6 reminders
- Activity HIGH: +30% = ~8 reminders
- Asam Urat: +50% = 12 reminders total
- 5 meal reminders (2 snacks added for children)
- Asam Urat health note reminder added

---

## Example 4: Teen (13-18) with Diabetes

**Profile**:
- Age: 13-18 (Teen)
- Activity: Medium
- Health Conditions: Diabetes
- Gender: Female

**Generated Schedule** (8 water + 4 meals + 3 diabetes checks):
```
06:45 - Check blood sugar (before breakfast)
07:00 - Breakfast
07:48 - Water glass 1
08:36 - Water glass 2
09:24 - Water glass 3
10:12 - Water glass 4
11:45 - Check blood sugar (before lunch)
12:00 - Lunch
13:00 - Water glass 5
14:00 - Water glass 6
15:00 - Snack
15:48 - Water glass 7
16:36 - Water glass 8
18:15 - Check blood sugar (before dinner)
18:30 - Dinner
```

**Total**: 15 reminders

**Notes**:
- Base teen: 8 reminders
- Activity MEDIUM: no change = 8 reminders
- Diabetes doesn't reduce base, but adds checks
- 3 blood sugar checks added (15-min before meals)

---

## Example 5: Adult with Multiple Conditions

**Profile**:
- Age: 19-65 (Adult)
- Activity: High
- Health Conditions: [Diabetes, Hypertension, Asam Urat]
- Gender: Male

**Generated Schedule** (calculation):
- Base adult: 10 reminders
- Activity HIGH: +30% = 13 reminders
- Diabetes: no reduction (special checks instead)
- Hypertension: -40% from 13 = 8 reminders
- Asam Urat: +50% from 8 = 12 reminders
- **Final:** clamp(12, 4, 18) = **12 water reminders** + meals + health checks
- **Total:** ~20 reminders

**Generated Schedule**:
```
06:45 - Check blood sugar (before breakfast)
07:00 - Breakfast
07:50 - Water glass 1
08:40 - Water glass 2
09:30 - Water glass 3
10:20 - Water glass 4
11:45 - Check blood sugar (before lunch)
12:00 - Lunch
12:50 - Water glass 5
13:40 - Water glass 6
14:30 - Water glass 7
15:00 - Snack
15:20 - Water glass 8
16:10 - Water glass 9
17:00 - Water glass 10
18:15 - Check blood sugar (before dinner)
18:30 - Dinner
19:20 - Water glass 11
20:10 - Water glass 12
20:00 - Asam urat: Tingkatkan intake air
```

**Total**: 22 reminders

---

## Algorithm Overview

### Step 1: Calculate Base Count
```
Base = AgeGroupDefault (4-10) 
       × ActivityMultiplier (0.8-1.3)
```

### Step 2: Apply Health Condition Multipliers
```
Adjusted = Base × HealthConditionFactor
Factors:
  - Diabetes: 1.0 (no change, special checks)
  - Asam Urat: 1.5 (+50%)
  - Hypertension: 0.6 (-40%)
  - Kidney: 0.7 (-30%)
```

### Step 3: Clamp to Safe Range
```
Final = clamp(Adjusted, 4, 18)
Min: 4 reminders/day (health minimum)
Max: 18 reminders/day (sanity limit)
```

### Step 4: Generate Time Distribution
- Evenly distribute reminders across 7 AM - 9 PM (14 hours)
- Use: `minuteOffset = (index * totalMinutes / count)`

### Step 5: Add Condition-Specific Reminders
- **Diabetes**: Blood sugar checks 15-min before meals
- **Hypertension**: Morning BP check
- **Asam Urat**: Evening intake reminder
- **Kidney**: Doctor consultation note

---

## Default Quantities

All water reminders default to: **250ml** (1 standard glass)

---

## Meal Timing by Age Group

| Age Group | Times | Notes |
|-----------|-------|-------|
| Child (5-12) | 7:00, 10:00, 12:00, 15:00, 18:00 | 2 snacks included |
| Teen/Adult | 7:00, 12:00, 15:00, 18:30 | 1 snack |
| Senior (65+) | 6:30, 11:30, 15:00, 17:30 | Early dinner |

---

## Testing the Service

```dart
// Test case 1: Adult with no conditions
final profile1 = UserProfile(
  id: null,
  gender: 'male',
  ageRange: AgeRange.adult,
  healthConditions: [HealthCondition.none],
  activityLevel: ActivityLevel.medium,
  createdAt: DateTime.now(),
);

final reminders1 = ScheduleGenerationService.generateDefaultSchedule(profile1);
print('Adult no conditions: ${reminders1.length} reminders');

// Test case 2: Child with Asam Urat + high activity
final profile2 = UserProfile(
  id: null,
  gender: 'male',
  ageRange: AgeRange.child,
  healthConditions: [HealthCondition.asamUrat],
  activityLevel: ActivityLevel.high,
  createdAt: DateTime.now(),
);

final reminders2 = ScheduleGenerationService.generateDefaultSchedule(profile2);
print('Child asam urat high activity: ${reminders2.length} reminders');

// Test case 3: Senior with Hypertension + low activity
final profile3 = UserProfile(
  id: null,
  gender: 'female',
  ageRange: AgeRange.senior,
  healthConditions: [HealthCondition.hypertension],
  activityLevel: ActivityLevel.low,
  createdAt: DateTime.now(),
);

final reminders3 = ScheduleGenerationService.generateDefaultSchedule(profile3);
print('Senior hypertension low activity: ${reminders3.length} reminders');
```

---

## Key Design Decisions

1. **Clamp Between 4-18**: Ensures physiologically safe hydration levels
2. **Even Distribution**: Spreads reminders naturally across waking hours (7 AM - 9 PM)
3. **Health Condition Priority**: Reductions for restrictions (HTN, kidney) take precedence
4. **Special Condition Checks**: Diabetes gets checks instead of arbitrary reduction
5. **Meal Timings**: Age-specific patterns for better UX

---

**Generated**: March 8, 2026

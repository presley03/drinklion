import 'package:drinklion/core/config/enums.dart';
import 'package:drinklion/domain/entities/entities.dart';

class ScheduleGenerationService {
  /// Generate default reminders based on user profile
  /// Takes into account: age, health conditions, activity level
  static List<ReminderLog> generateDefaultSchedule(UserProfile profile) {
    final reminders = <ReminderLog>[];

    // Base frequency depends on age + activity level
    int baseWaterRemindersPerDay = _getBaseWaterRemindersPerDay(
      profile.ageRange,
      profile.activityLevel,
    );

    // Adjust for health conditions
    baseWaterRemindersPerDay = _adjustForHealthConditions(
      baseWaterRemindersPerDay,
      profile,
    );

    // Generate water reminders at intervals
    reminders.addAll(_generateWaterReminders(baseWaterRemindersPerDay));

    // Add meal reminders (if not children)
    if (profile.ageRange != AgeRange.child) {
      reminders.addAll(_generateMealReminders(profile.ageRange));
    }

    // Add diabetes-specific reminders
    if (profile.healthConditions.contains(HealthCondition.diabetes)) {
      reminders.addAll(_generateDiabetesReminders());
    }

    // Add condition-specific notes
    reminders.addAll(_generateConditionNotes(profile));

    return reminders;
  }

  /// Base water reminders per day based on age + activity
  static int _getBaseWaterRemindersPerDay(
    AgeRange ageRange,
    ActivityLevel activityLevel,
  ) {
    final baseByAge = {
      AgeRange.child: 6, // Kids: smaller portions, more frequent
      AgeRange.teen: 8,
      AgeRange.adult: 10,
      AgeRange.senior: 8, // Less fluid need, risk of overhydration
    };

    int base = baseByAge[ageRange] ?? 8;

    // Adjust by activity level
    if (activityLevel == ActivityLevel.high) {
      base = (base * 1.3).round(); // +30% for high activity
    } else if (activityLevel == ActivityLevel.low) {
      base = (base * 0.8).round(); // -20% for low activity
    }

    return base;
  }

  /// Adjust reminder frequency based on health conditions
  static int _adjustForHealthConditions(int baseCount, UserProfile profile) {
    int adjusted = baseCount;

    for (final condition in profile.healthConditions) {
      switch (condition) {
        case HealthCondition.diabetes:
          // Monitor more frequently before meals
          adjusted = baseCount; // Keep base, add special diabetes reminders
          break;

        case HealthCondition.asamUrat:
          // Need more water to dilute uric acid
          adjusted = (adjusted * 1.5).round(); // +50%
          break;

        case HealthCondition.hypertension:
          // Reduce fluid intake
          adjusted = (adjusted * 0.6).round(); // -40%
          break;

        case HealthCondition.kidney:
          // Varies by stage - start conservative
          adjusted = (adjusted * 0.7).round(); // -30%
          break;

        case HealthCondition.none:
          // No adjustment
          break;
      }
    }

    // Ensure minimum of 4 reminders per day and max of 18
    return adjusted.clamp(4, 18);
  }

  /// Generate water reminder times distributed throughout the day
  static List<ReminderLog> _generateWaterReminders(int count) {
    final reminders = <ReminderLog>[];
    final now = DateTime.now();

    // Distribute evenly from 7 AM to 9 PM (14 hours = 840 minutes)
    const int startHour = 7;
    const int endHour = 21;
    const int hoursInDay = endHour - startHour; // 14 hours

    for (int i = 0; i < count; i++) {
      final minuteOffset = (i * (hoursInDay * 60) / count).round();
      final scheduledHour = startHour + (minuteOffset ~/ 60);
      final scheduledMinute = minuteOffset % 60;

      reminders.add(
        ReminderLog(
          id: 'water_${i + 1}',
          type: ReminderType.drink,
          scheduledTime: DateTime(
            now.year,
            now.month,
            now.day,
            scheduledHour,
            scheduledMinute,
          ),
          isCompleted: false,
          createdAt: now,
          quantity: _getWaterQuantity(), // Default: 1 glass = 250ml
        ),
      );
    }

    return reminders;
  }

  /// Generate meal reminders
  static List<ReminderLog> _generateMealReminders(AgeRange ageRange) {
    final reminders = <ReminderLog>[];
    final now = DateTime.now();

    if (ageRange == AgeRange.child) {
      // Age 5-12: Breakfast, 2x snacks, lunch, dinner
      reminders.addAll([
        ReminderLog(
          id: 'meal_breakfast',
          type: ReminderType.meal,
          mealType: MealType.breakfast,
          scheduledTime: DateTime(now.year, now.month, now.day, 7, 0),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_snack1',
          type: ReminderType.meal,
          mealType: MealType.snack,
          scheduledTime: DateTime(now.year, now.month, now.day, 10, 0),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_lunch',
          type: ReminderType.meal,
          mealType: MealType.lunch,
          scheduledTime: DateTime(now.year, now.month, now.day, 12, 0),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_snack2',
          type: ReminderType.meal,
          mealType: MealType.snack,
          scheduledTime: DateTime(now.year, now.month, now.day, 15, 0),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_dinner',
          type: ReminderType.meal,
          mealType: MealType.dinner,
          scheduledTime: DateTime(now.year, now.month, now.day, 18, 0),
          isCompleted: false,
          createdAt: now,
        ),
      ]);
    } else if (ageRange == AgeRange.senior) {
      // Lansia 65+: Earlier meals, lighter dinners
      reminders.addAll([
        ReminderLog(
          id: 'meal_breakfast',
          type: ReminderType.meal,
          mealType: MealType.breakfast,
          scheduledTime: DateTime(now.year, now.month, now.day, 6, 30),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_lunch',
          type: ReminderType.meal,
          mealType: MealType.lunch,
          scheduledTime: DateTime(now.year, now.month, now.day, 11, 30),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_snack',
          type: ReminderType.meal,
          mealType: MealType.snack,
          scheduledTime: DateTime(now.year, now.month, now.day, 15, 0),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_dinner',
          type: ReminderType.meal,
          mealType: MealType.dinner,
          scheduledTime: DateTime(now.year, now.month, now.day, 17, 30),
          isCompleted: false,
          createdAt: now,
        ),
      ]);
    } else {
      // Teen + Adult: Standard 3 meals + 1 snack
      reminders.addAll([
        ReminderLog(
          id: 'meal_breakfast',
          type: ReminderType.meal,
          mealType: MealType.breakfast,
          scheduledTime: DateTime(now.year, now.month, now.day, 7, 0),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_lunch',
          type: ReminderType.meal,
          mealType: MealType.lunch,
          scheduledTime: DateTime(now.year, now.month, now.day, 12, 0),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_snack',
          type: ReminderType.meal,
          mealType: MealType.snack,
          scheduledTime: DateTime(now.year, now.month, now.day, 15, 0),
          isCompleted: false,
          createdAt: now,
        ),
        ReminderLog(
          id: 'meal_dinner',
          type: ReminderType.meal,
          mealType: MealType.dinner,
          scheduledTime: DateTime(now.year, now.month, now.day, 18, 30),
          isCompleted: false,
          createdAt: now,
        ),
      ]);
    }

    return reminders;
  }

  /// Generate diabetes-specific reminders (blood sugar check before meals)
  static List<ReminderLog> _generateDiabetesReminders() {
    final reminders = <ReminderLog>[];
    final now = DateTime.now();

    // Add 15-min before meal checks
    reminders.addAll([
      ReminderLog(
        id: 'diabetes_before_breakfast',
        type: ReminderType.drink,
        scheduledTime: DateTime(now.year, now.month, now.day, 6, 45),
        isCompleted: false,
        createdAt: now,
        skippedReason: 'Check blood sugar before breakfast',
      ),
      ReminderLog(
        id: 'diabetes_before_lunch',
        type: ReminderType.drink,
        scheduledTime: DateTime(now.year, now.month, now.day, 11, 45),
        isCompleted: false,
        createdAt: now,
        skippedReason: 'Check blood sugar before lunch',
      ),
      ReminderLog(
        id: 'diabetes_before_dinner',
        type: ReminderType.drink,
        scheduledTime: DateTime(now.year, now.month, now.day, 18, 15),
        isCompleted: false,
        createdAt: now,
        skippedReason: 'Check blood sugar before dinner',
      ),
    ]);

    return reminders;
  }

  /// Generate health condition-specific notes/reminders
  static List<ReminderLog> _generateConditionNotes(UserProfile profile) {
    final reminders = <ReminderLog>[];
    final now = DateTime.now();

    for (final condition in profile.healthConditions) {
      switch (condition) {
        case HealthCondition.hypertension:
          // Morning blood pressure check
          reminders.add(
            ReminderLog(
              id: 'health_bp_check',
              type: ReminderType.drink,
              scheduledTime: DateTime(now.year, now.month, now.day, 7, 30),
              isCompleted: false,
              createdAt: now,
              skippedReason: 'Check blood pressure (morning)',
            ),
          );
          break;

        case HealthCondition.asamUrat:
          // Reminder untuk increase intake
          reminders.add(
            ReminderLog(
              id: 'health_uric_acid',
              type: ReminderType.drink,
              scheduledTime: DateTime(now.year, now.month, now.day, 20, 0),
              isCompleted: false,
              createdAt: now,
              skippedReason: 'Asam urat: Tingkatkan intake air',
            ),
          );
          break;

        case HealthCondition.kidney:
          // These need doctor consultation first
          reminders.add(
            ReminderLog(
              id: 'health_kidney_alert',
              type: ReminderType.drink,
              scheduledTime: DateTime(now.year, now.month, now.day, 8, 0),
              isCompleted: false,
              createdAt: now,
              skippedReason: 'Konsultasi dokter untuk jadwal minum yang tepat',
            ),
          );
          break;

        case HealthCondition.none:
        case HealthCondition.diabetes:
          break;
      }
    }

    return reminders;
  }

  /// Get default water quantity based on standard glass
  static String _getWaterQuantity() {
    return '250'; // 1 glass = 250ml (standard)
  }
}

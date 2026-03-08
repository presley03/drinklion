enum ReminderType { drink, meal }

enum MealType { breakfast, lunch, dinner, snack }

enum ActivityLevel { low, medium, high }

enum AgeRange { child, teen, adult, senior }

enum Gender { male, female }

enum HealthCondition { none, diabetes, hypertension, asamUrat, kidney }

// Map age range strings
final ageRangeMap = {
  '5-12': AgeRange.child,
  '13-18': AgeRange.teen,
  '19-65': AgeRange.adult,
  '65+': AgeRange.senior,
};

String ageRangeToString(AgeRange ageRange) {
  switch (ageRange) {
    case AgeRange.child:
      return '5-12';
    case AgeRange.teen:
      return '13-18';
    case AgeRange.adult:
      return '19-65';
    case AgeRange.senior:
      return '65+';
  }
}

String activityLevelToString(ActivityLevel level) {
  switch (level) {
    case ActivityLevel.low:
      return 'low';
    case ActivityLevel.medium:
      return 'medium';
    case ActivityLevel.high:
      return 'high';
  }
}

String reminderTypeToString(ReminderType type) {
  return type == ReminderType.drink ? 'drink' : 'meal';
}

String mealTypeToString(MealType mealType) {
  switch (mealType) {
    case MealType.breakfast:
      return 'breakfast';
    case MealType.lunch:
      return 'lunch';
    case MealType.dinner:
      return 'dinner';
    case MealType.snack:
      return 'snack';
  }
}

part of 'history_bloc.dart';

/// Base state for HistoryBloc
abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

/// Loading state
class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

/// History data loaded
class HistoryLoaded extends HistoryState {
  final List<ReminderLog> reminders;
  final Map<String, dynamic> statistics;

  const HistoryLoaded({required this.reminders, required this.statistics});

  @override
  List<Object?> get props => [reminders, statistics];
}

/// Weekly statistics loaded
class WeeklyStatsLoaded extends HistoryState {
  final Map<String, double> dailyRates; // Day -> completion rate
  final double weeklyAverage;
  final int totalReminders;
  final int completedReminders;

  const WeeklyStatsLoaded({
    required this.dailyRates,
    required this.weeklyAverage,
    required this.totalReminders,
    required this.completedReminders,
  });

  @override
  List<Object?> get props => [
    dailyRates,
    weeklyAverage,
    totalReminders,
    completedReminders,
  ];
}

/// Monthly statistics loaded
class MonthlyStatsLoaded extends HistoryState {
  final Map<String, double> weeklyRates; // Week -> completion rate
  final double monthlyAverage;
  final int totalReminders;
  final int completedReminders;

  const MonthlyStatsLoaded({
    required this.weeklyRates,
    required this.monthlyAverage,
    required this.totalReminders,
    required this.completedReminders,
  });

  @override
  List<Object?> get props => [
    weeklyRates,
    monthlyAverage,
    totalReminders,
    completedReminders,
  ];
}

/// History exported successfully
class HistoryExported extends HistoryState {
  final String filePath;

  const HistoryExported(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// No history found
class NoHistoryFound extends HistoryState {
  const NoHistoryFound();
}

/// Error state
class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

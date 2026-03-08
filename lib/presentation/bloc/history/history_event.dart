part of 'history_bloc.dart';

/// Base event for HistoryBloc
abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load history for today
class LoadTodayHistoryEvent extends HistoryEvent {
  const LoadTodayHistoryEvent();
}

/// Load history for a specific date
class LoadHistoryByDateEvent extends HistoryEvent {
  final DateTime date;

  const LoadHistoryByDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

/// Load history for a date range (weekly/monthly)
class LoadHistoryByRangeEvent extends HistoryEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadHistoryByRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Load weekly statistics
class LoadWeeklyStatsEvent extends HistoryEvent {
  const LoadWeeklyStatsEvent();
}

/// Load monthly statistics
class LoadMonthlyStatsEvent extends HistoryEvent {
  const LoadMonthlyStatsEvent();
}

/// Export history data
class ExportHistoryEvent extends HistoryEvent {
  const ExportHistoryEvent();
}

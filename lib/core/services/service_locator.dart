import 'package:get_it/get_it.dart';
import 'package:drinklion/data/database/app_database.dart';
import 'package:drinklion/data/datasources/local_data_source.dart';
import 'package:drinklion/data/datasources/local_data_source_impl.dart';
import 'package:drinklion/data/repositories/repositories.dart';
import 'package:drinklion/domain/repositories/repositories.dart';
import 'package:drinklion/core/services/user_context_service.dart';
import 'package:drinklion/core/services/notification_manager.dart';
import 'package:drinklion/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:drinklion/presentation/bloc/reminder/reminder_bloc.dart';
import 'package:drinklion/presentation/bloc/history/history_bloc.dart';
import 'package:drinklion/presentation/bloc/settings/settings_bloc.dart';
import 'package:drinklion/presentation/bloc/fasting/fasting_bloc.dart';
import 'package:drinklion/presentation/bloc/notification/notification_bloc.dart';

final getIt = GetIt.instance;

/// Setup service locator
Future<void> setupServiceLocator() async {
  // User context service (singleton for tracking current user)
  getIt.registerSingleton<UserContextService>(UserContextService());

  // Notification manager (singleton for handling notifications)
  final notificationManager = NotificationManager();
  NotificationManager.initializeTimezoneData(); // Initialize timezone data
  getIt.registerSingleton<NotificationManager>(notificationManager);
  await notificationManager.initialize();

  // Database
  final appDatabase = AppDatabase();
  await appDatabase.getDatabase(); // Initialize database

  // Data sources
  final localDataSource = LocalDataSourceImpl(appDatabase);
  await localDataSource.initialize(); // Initialize data source
  getIt.registerSingleton<LocalDataSource>(localDataSource);

  // Repositories
  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(getIt<LocalDataSource>(), getIt<UserContextService>()),
  );

  getIt.registerSingleton<ReminderRepository>(
    ReminderRepositoryImpl(
      getIt<LocalDataSource>(),
      getIt<UserContextService>(),
    ),
  );

  getIt.registerSingleton<NotificationRepository>(
    NotificationRepositoryImpl(
      getIt<LocalDataSource>(),
      getIt<UserContextService>(),
    ),
  );

  // BLoCs
  getIt.registerSingleton<UserProfileBloc>(
    UserProfileBloc(getIt<UserRepository>(), getIt<ReminderRepository>()),
  );

  getIt.registerSingleton<ReminderBloc>(
    ReminderBloc(getIt<ReminderRepository>()),
  );

  getIt.registerSingleton<HistoryBloc>(
    HistoryBloc(getIt<ReminderRepository>()),
  );

  getIt.registerSingleton<SettingsBloc>(SettingsBloc(getIt<UserRepository>()));

  getIt.registerSingleton<FastingBloc>(FastingBloc(getIt<UserRepository>()));

  getIt.registerSingleton<NotificationBloc>(
    NotificationBloc(
      getIt<NotificationRepository>(),
      getIt<NotificationManager>(),
    ),
  );
}

/// Dispose all resources
Future<void> disposeServiceLocator() async {
  if (getIt.isRegistered<LocalDataSource>()) {
    await getIt<LocalDataSource>().close();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drinklion/core/theme/app_theme.dart';
import 'package:drinklion/core/services/service_locator.dart';
import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:drinklion/presentation/bloc/reminder/reminder_bloc.dart';
import 'package:drinklion/presentation/bloc/history/history_bloc.dart';
import 'package:drinklion/presentation/bloc/settings/settings_bloc.dart';
import 'package:drinklion/presentation/bloc/fasting/fasting_bloc.dart';
import 'package:drinklion/presentation/bloc/notification/notification_bloc.dart';
import 'package:drinklion/presentation/screens/splash_screen.dart';
import 'package:drinklion/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:drinklion/presentation/screens/home/home_screen.dart';
import 'package:drinklion/presentation/screens/settings/settings_screen.dart';
import 'package:drinklion/presentation/screens/history/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Setup service locator (GetIt)
    await setupServiceLocator();
    logger.i('Service locator initialized');
  } catch (e) {
    logger.e('Error initializing service locator', error: e);
    rethrow;
  }

  runApp(const DrinkLionApp());
}

class DrinkLionApp extends StatelessWidget {
  const DrinkLionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserProfileBloc>(
          create: (context) => getIt<UserProfileBloc>(),
        ),
        BlocProvider<ReminderBloc>(create: (context) => getIt<ReminderBloc>()),
        BlocProvider<HistoryBloc>(create: (context) => getIt<HistoryBloc>()),
        BlocProvider<SettingsBloc>(create: (context) => getIt<SettingsBloc>()),
        BlocProvider<FastingBloc>(create: (context) => getIt<FastingBloc>()),
        BlocProvider<NotificationBloc>(
          create: (context) => getIt<NotificationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'DrinkLion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/home': (context) => const HomeScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/history': (context) => const HistoryScreen(),
        },
      ),
    );
  }
}

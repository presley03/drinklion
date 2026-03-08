import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_profile/user_profile_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.read<UserProfileBloc>().add(const CheckOnboardingStatusEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is NoUserProfileFound) {
            Navigator.of(context).pushReplacementNamed('/onboarding');
          } else if (state is OnboardingCompleted) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is UserProfileError) {
            // Fallback to onboarding on error
            Navigator.of(context).pushReplacementNamed('/onboarding');
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.local_drink,
                  size: 60,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'DrinkLion',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reminder Minum Air',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

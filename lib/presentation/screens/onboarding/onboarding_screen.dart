import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_profile/user_profile_bloc.dart';
import 'package:drinklion/core/config/enums.dart';
import 'screens/gender_screen.dart';
import 'screens/age_screen.dart';
import 'screens/health_conditions_screen.dart';
import 'screens/activity_level_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  // Form data
  Gender? _selectedGender;
  AgeRange? _selectedAge;
  Set<HealthCondition> _selectedConditions = {};
  ActivityLevel? _selectedActivityLevel;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 3) {
      _saveUserProfile();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveUserProfile() {
    if (_selectedGender == null ||
        _selectedAge == null ||
        _selectedConditions.isEmpty ||
        _selectedActivityLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }

    context.read<UserProfileBloc>().add(
      CreateUserProfileEvent(
        gender: _selectedGender?.name,
        ageRange: _selectedAge?.name,
        healthConditions: _selectedConditions.map((c) => c.name).toList(),
        activityLevel: _selectedActivityLevel?.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileCreated) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is UserProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentPage + 1) / 4,
              minHeight: 4,
            ),
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  GenderScreen(
                    onGenderSelected: (gender) {
                      setState(() {
                        _selectedGender = gender;
                      });
                    },
                    selectedGender: _selectedGender,
                  ),
                  AgeScreen(
                    onAgeSelected: (age) {
                      setState(() {
                        _selectedAge = age;
                      });
                    },
                    selectedAge: _selectedAge,
                  ),
                  HealthConditionsScreen(
                    onConditionsSelected: (conditions) {
                      setState(() {
                        _selectedConditions = conditions;
                      });
                    },
                    selectedConditions: _selectedConditions,
                  ),
                  ActivityLevelScreen(
                    onActivitySelected: (activity) {
                      setState(() {
                        _selectedActivityLevel = activity;
                      });
                    },
                    selectedActivity: _selectedActivityLevel,
                  ),
                ],
              ),
            ),
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Kembali'),
                    )
                  else
                    const SizedBox(width: 100),
                  FilledButton(
                    onPressed: _nextPage,
                    child: Text(_currentPage == 3 ? 'Selesai' : 'Lanjut'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

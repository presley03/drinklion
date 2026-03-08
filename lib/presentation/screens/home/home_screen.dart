import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/fasting/fasting_bloc.dart';
import '../../bloc/reminder/reminder_bloc.dart';
import 'widgets/reminder_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load today's reminders when screen opens
    context.read<ReminderBloc>().add(const LoadTodayRemindersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DrinkLion'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, reminderState) {
          if (reminderState is ReminderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reminderState is ReminderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Error: ${reminderState.message}'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<ReminderBloc>().add(
                        const LoadTodayRemindersEvent(),
                      );
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (reminderState is RemindersLoaded) {
            final reminders = reminderState.reminders;
            final completedCount = reminders.where((r) => r.isCompleted).length;
            final completionPercentage = reminders.isEmpty
                ? 0.0
                : (completedCount / reminders.length) * 100;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReminderBloc>().add(
                  const LoadTodayRemindersEvent(),
                );
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Greeting card
                  _buildGreetingCard(context, completionPercentage),
                  const SizedBox(height: 24),

                  // Fasting mode toggle
                  _buildFastingModeSection(context),
                  const SizedBox(height: 24),

                  // Today's reminders header
                  Text(
                    "Hari ini (${reminders.length} pengingat)",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reminders list
                  if (reminders.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Semua pengingat sudah selesai!',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...reminders.where((r) => r.id != null).map((reminder) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReminderCard(
                          reminder: reminder,
                          onMarkDone: () {
                            context.read<ReminderBloc>().add(
                              CompleteReminderEvent(reminderId: reminder.id!),
                            );
                          },
                          onRemindLater: () {
                            context.read<ReminderBloc>().add(
                              SkipReminderEvent(reminderId: reminder.id!),
                            );
                          },
                        ),
                      );
                    }).toList(),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGreetingCard(BuildContext context, double completionPercentage) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Pagi'
        : hour < 17
        ? 'Siang'
        : 'Sore';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat $greeting! 👋',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selamat tinggal dehidrasi!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progres Hari Ini',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: completionPercentage / 100,
                        minHeight: 8,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${completionPercentage.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFastingModeSection(BuildContext context) {
    return BlocBuilder<FastingBloc, FastingState>(
      builder: (context, fastingState) {
        final isFastingEnabled = fastingState is FastingEnabled;

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isFastingEnabled
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.nights_stay,
                color: isFastingEnabled
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mode Puasa',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      isFastingEnabled
                          ? 'Pengingat dimatikan saat puasa'
                          : 'Aktifkan untuk mematikan pengingat saat puasa',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isFastingEnabled,
                onChanged: (value) {
                  if (value) {
                    context.read<FastingBloc>().add(
                      const EnableFastingModeEvent(),
                    );
                  } else {
                    context.read<FastingBloc>().add(
                      const DisableFastingModeEvent(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/history/history_bloc.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const LoadTodayHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HistoryError) {
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
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<HistoryBloc>().add(
                        const LoadTodayHistoryEvent(),
                      );
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is HistoryLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HistoryBloc>().add(const LoadTodayHistoryEvent());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Statistics cards
                  _buildStatCard(
                    context,
                    title: 'Pengingat Hari Ini',
                    value: '8',
                    icon: Icons.today,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    context,
                    title: 'Selesai Minggu Ini',
                    value: '45/56',
                    icon: Icons.calendar_month,
                    subtitle: '80% completion rate',
                  ),
                  const SizedBox(height: 24),

                  // Recent activities
                  Text(
                    'Aktivitas Terbaru',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    5,
                    (index) => _buildActivityItem(context, index),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    String? subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, int index) {
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
    final completion = [95, 88, 92, 85, 90];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  days[index],
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${completion[index]}% selesai',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            Icon(
              completion[index] >= 90
                  ? Icons.check_circle
                  : Icons.incomplete_circle,
              color: completion[index] >= 90
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}

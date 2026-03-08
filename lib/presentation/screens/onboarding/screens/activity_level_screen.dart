import 'package:flutter/material.dart';
import 'package:drinklion/core/config/enums.dart';

class ActivityLevelScreen extends StatelessWidget {
  final Function(ActivityLevel) onActivitySelected;
  final ActivityLevel? selectedActivity;

  const ActivityLevelScreen({
    Key? key,
    required this.onActivitySelected,
    this.selectedActivity,
  }) : super(key: key);

  String _getActivityLabel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.low:
        return 'Aktivitas Ringan';
      case ActivityLevel.medium:
        return 'Aktivitas Sedang';
      case ActivityLevel.high:
        return 'Aktivitas Tinggi';
    }
  }

  String _getActivityDescription(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.low:
        return 'Pekerjaan kantor, jarang olahraga';
      case ActivityLevel.medium:
        return 'Pekerjaan manual ringan, olahraga rutin';
      case ActivityLevel.high:
        return 'Pekerjaan fisik berat, atlet profesional';
    }
  }

  IconData _getActivityIcon(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.low:
        return Icons.work;
      case ActivityLevel.medium:
        return Icons.directions_walk;
      case ActivityLevel.high:
        return Icons.sports_gymnastics;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'Tingkat aktivitas Anda?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Ini membantu menyesuaikan jumlah air yang perlu diminum',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ...ActivityLevel.values.map((activity) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () => onActivitySelected(activity),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedActivity == activity
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: selectedActivity == activity ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: selectedActivity == activity
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        _getActivityIcon(activity),
                        color: selectedActivity == activity
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getActivityLabel(activity),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: selectedActivity == activity
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getActivityDescription(activity),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

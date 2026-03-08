import 'package:flutter/material.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/core/config/enums.dart';

class ReminderCard extends StatelessWidget {
  final ReminderLog reminder;
  final VoidCallback onMarkDone;
  final VoidCallback onRemindLater;

  const ReminderCard({
    Key? key,
    required this.reminder,
    required this.onMarkDone,
    required this.onRemindLater,
  }) : super(key: key);

  String _getReminderTitle(ReminderType type, MealType? mealType) {
    if (type == ReminderType.drink) {
      return 'Minum Air';
    }
    if (type == ReminderType.meal && mealType != null) {
      switch (mealType) {
        case MealType.breakfast:
          return 'Sarapan';
        case MealType.lunch:
          return 'Makan Siang';
        case MealType.dinner:
          return 'Makan Malam';
        case MealType.snack:
          return 'Camilan';
      }
    }
    return 'Pengingat';
  }

  Color _getReminderColor(BuildContext context, ReminderType type) {
    if (type == ReminderType.drink) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.tertiary;
    }
  }

  IconData _getReminderIcon(ReminderType type) {
    return type == ReminderType.drink ? Icons.local_drink : Icons.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    final title = _getReminderTitle(reminder.type, reminder.mealType);
    final color = _getReminderColor(context, reminder.type);
    final icon = _getReminderIcon(reminder.type);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: reminder.isCompleted ? color.withOpacity(0.5) : color,
        ),
        borderRadius: BorderRadius.circular(12),
        color: reminder.isCompleted
            ? color.withOpacity(0.1)
            : color.withOpacity(0.05),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: reminder.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                        ),
                        if (reminder.isCompleted)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.check_circle,
                              size: 20,
                              color: color,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pukul ${reminder.scheduledTime}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (reminder.quantity != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Text(
                'Jumlah: ${reminder.quantity} ml',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ],
          if (!reminder.isCompleted) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: onRemindLater,
                      child: const Text('Tunda 30m'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: onMarkDone,
                      child: const Text('Selesai'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:drinklion/core/config/enums.dart';

class HealthConditionsScreen extends StatefulWidget {
  final Function(Set<HealthCondition>) onConditionsSelected;
  final Set<HealthCondition> selectedConditions;

  const HealthConditionsScreen({
    Key? key,
    required this.onConditionsSelected,
    required this.selectedConditions,
  }) : super(key: key);

  @override
  State<HealthConditionsScreen> createState() => _HealthConditionsScreenState();
}

class _HealthConditionsScreenState extends State<HealthConditionsScreen> {
  late Set<HealthCondition> _localSelected;

  @override
  void initState() {
    super.initState();
    _localSelected = Set<HealthCondition>.from(widget.selectedConditions);
  }

  String _getConditionLabel(HealthCondition condition) {
    switch (condition) {
      case HealthCondition.none:
        return 'Tidak ada kondisi khusus';
      case HealthCondition.diabetes:
        return 'Diabetes';
      case HealthCondition.hypertension:
        return 'Tekanan Darah Tinggi';
      case HealthCondition.asamUrat:
        return 'Asam Urat';
      case HealthCondition.kidney:
        return 'Penyakit Ginjal';
    }
  }

  String _getConditionDescription(HealthCondition condition) {
    switch (condition) {
      case HealthCondition.none:
        return 'Keadaan kesehatan normal';
      case HealthCondition.diabetes:
        return 'Perlu monitor kadar gula darah';
      case HealthCondition.hypertension:
        return 'Perlu kontrol asupan air';
      case HealthCondition.asamUrat:
        return 'Perlu lebih banyak minum air';
      case HealthCondition.kidney:
        return 'Perlu konsultasi dokter';
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
            Icons.health_and_safety,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'Kondisi kesehatan?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Pilih semua yang sesuai (bisa lebih dari satu)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: HealthCondition.values.map((condition) {
                final isSelected = _localSelected.contains(condition);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _localSelected.remove(condition);
                        } else {
                          _localSelected.add(condition);
                        }
                        widget.onConditionsSelected(_localSelected);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.transparent,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              setState(() {
                                if (isSelected) {
                                  _localSelected.remove(condition);
                                } else {
                                  _localSelected.add(condition);
                                }
                                widget.onConditionsSelected(_localSelected);
                              });
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getConditionLabel(condition),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getConditionDescription(condition),
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
            ),
          ),
        ],
      ),
    );
  }
}

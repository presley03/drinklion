import 'package:flutter/material.dart';
import 'package:drinklion/core/config/enums.dart';

class GenderScreen extends StatelessWidget {
  final Function(Gender) onGenderSelected;
  final Gender? selectedGender;

  const GenderScreen({
    Key? key,
    required this.onGenderSelected,
    this.selectedGender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'Apa jenis kelamin Anda?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Informasi ini membantu kami menyesuaikan jadwal minum air',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ...Gender.values.map((gender) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () => onGenderSelected(gender),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedGender == gender
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: selectedGender == gender ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: selectedGender == gender
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        gender == Gender.male ? Icons.male : Icons.female,
                        color: selectedGender == gender
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        gender == Gender.male ? 'Laki-laki' : 'Perempuan',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: selectedGender == gender
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
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

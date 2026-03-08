import 'package:flutter/material.dart';
import 'package:drinklion/core/config/enums.dart';

class AgeScreen extends StatelessWidget {
  final Function(AgeRange) onAgeSelected;
  final AgeRange? selectedAge;

  const AgeScreen({Key? key, required this.onAgeSelected, this.selectedAge})
    : super(key: key);

  String _getAgeLabel(AgeRange range) {
    switch (range) {
      case AgeRange.child:
        return 'Anak-anak (5-12 tahun)';
      case AgeRange.teen:
        return 'Remaja (13-18 tahun)';
      case AgeRange.adult:
        return 'Dewasa (19-65 tahun)';
      case AgeRange.senior:
        return 'Lansia (65+ tahun)';
    }
  }

  String _getAgeDescription(AgeRange range) {
    switch (range) {
      case AgeRange.child:
        return 'Dengan potensi aktivitas tinggi';
      case AgeRange.teen:
        return 'Usia sekolah hingga dewasa awal';
      case AgeRange.adult:
        return 'Dewasa dengan aktivitas normal';
      case AgeRange.senior:
        return 'Lanjut usia dengan kebutuhan khusus';
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
            Icons.cake,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'Berapa umur Anda?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Ini membantu menyesuaikan frekuensi minum air',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ...AgeRange.values.map((age) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () => onAgeSelected(age),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedAge == age
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: selectedAge == age ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: selectedAge == age
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getAgeLabel(age),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: selectedAge == age
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getAgeDescription(age),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
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

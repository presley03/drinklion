import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification settings
          Text(
            'Notifikasi',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            context,
            title: 'Suara Notifikasi',
            icon: Icons.volume_up,
            trailing: Switch(
              value: true,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateNotificationSoundEvent(value),
                );
              },
            ),
          ),
          _buildSettingTile(
            context,
            title: 'Getaran',
            icon: Icons.vibration,
            trailing: Switch(
              value: true,
              onChanged: (value) {
                context.read<SettingsBloc>().add(UpdateVibrationEvent(value));
              },
            ),
          ),
          const SizedBox(height: 24),

          // Theme settings
          Text(
            'Tampilan',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            context,
            title: 'Mode Gelap',
            icon: Icons.dark_mode,
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateThemeEvent(value ? 'dark' : 'light'),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // About
          Text(
            'Tentang',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            context,
            title: 'Versi Aplikasi',
            subtitle: '1.0.0',
            icon: Icons.info,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
      ),
    );
  }
}

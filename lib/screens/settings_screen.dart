import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../providers/theme_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _selectedGoal;
  late ThemeMode _themeMode;
  late int _selectedInterval;

  @override
  void initState() {
    super.initState();
    _selectedGoal = context.read<WaterProvider>().dailyGoal;
    _selectedInterval = context.read<WaterProvider>().reminderInterval;
    _themeMode = context.read<ThemeProvider>().themeMode;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WaterProvider>();
    final themeProvider = context.read<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Daily goal (number of glasses):', style: TextStyle(fontSize: 16)),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _selectedGoal.toDouble(),
                  min: 4,
                  max: 16,
                  divisions: 12,
                  label: '$_selectedGoal',
                  onChanged: (v) => setState(() => _selectedGoal = v.round()),
                ),
              ),
              Text('$_selectedGoal'),
            ],
          ),
          const SizedBox(height: 36),
          const Text('Reminder interval:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          DropdownButton<int>(
            value: _selectedInterval,
            onChanged: (val) => setState(() => _selectedInterval = val ?? 2),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Every 1 hour')),
              DropdownMenuItem(value: 2, child: Text('Every 2 hours')),
              DropdownMenuItem(value: 3, child: Text('Every 3 hours')),
            ],
          ),
          const SizedBox(height: 36),
          const Text('Theme:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: _themeMode,
                  onChanged: (v) => setState(() => _themeMode = v!),
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: _themeMode,
                  onChanged: (v) => setState(() => _themeMode = v!),
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<ThemeMode>(
                  title: const Text('System'),
                  value: ThemeMode.system,
                  groupValue: _themeMode,
                  onChanged: (v) => setState(() => _themeMode = v!),
                  dense: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: () async {
              provider.setDailyGoal(_selectedGoal);
              provider.setReminderInterval(_selectedInterval);
              themeProvider.setTheme(_themeMode);

              await NotificationService.scheduleSingleNotification(intervalHours: _selectedInterval);

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

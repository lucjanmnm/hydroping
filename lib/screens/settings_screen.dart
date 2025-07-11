import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../providers/theme_provider.dart';

enum AppThemeMode { light, dark, system }

String themeLabel(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return 'Light theme';
    case AppThemeMode.dark:
      return 'Dark theme';
    case AppThemeMode.system:
      return 'System default';
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _selectedGoal;
  late int _selectedInterval;
  late bool _notificationsEnabled;
  late AppThemeMode _appThemeMode;

  @override
  void initState() {
    super.initState();
    final provider = context.read<WaterProvider>();
    _selectedGoal = provider.dailyGoal;
    _selectedInterval = provider.reminderInterval;
    _notificationsEnabled = provider.notificationsEnabled;

    final providerTheme = context.read<ThemeProvider>().themeMode;
    if (providerTheme == ThemeMode.light) {
      _appThemeMode = AppThemeMode.light;
    } else if (providerTheme == ThemeMode.dark) {
      _appThemeMode = AppThemeMode.dark;
    } else {
      _appThemeMode = AppThemeMode.system;
    }
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
          const SizedBox(height: 28),
          const Text('Reminders:', style: TextStyle(fontSize: 16)),
          SwitchListTile(
            title: const Text('Enable notifications'),
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          if (_notificationsEnabled) ...[
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _selectedInterval,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'How often?',
              ),
              onChanged: (v) => setState(() => _selectedInterval = v ?? 2),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Every 1 hour')),
                DropdownMenuItem(value: 2, child: Text('Every 2 hours')),
                DropdownMenuItem(value: 3, child: Text('Every 3 hours')),
              ],
            ),
          ],
          const SizedBox(height: 28),
          const Text('Theme:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          DropdownButtonFormField<AppThemeMode>(
            value: _appThemeMode,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'App theme',
            ),
            items: AppThemeMode.values.map((mode) {
              return DropdownMenuItem(
                value: mode,
                child: Text(themeLabel(mode)),
              );
            }).toList(),
            onChanged: (mode) {
              setState(() {
                _appThemeMode = mode!;
              });
            },
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: () {
              provider.setDailyGoal(_selectedGoal);
              provider.setReminderInterval(_selectedInterval);
              provider.setNotificationsEnabled(_notificationsEnabled);

              ThemeMode selectedFlutterTheme;
              switch (_appThemeMode) {
                case AppThemeMode.light:
                  selectedFlutterTheme = ThemeMode.light;
                  break;
                case AppThemeMode.dark:
                  selectedFlutterTheme = ThemeMode.dark;
                  break;
                default:
                  selectedFlutterTheme = ThemeMode.system;
              }
              themeProvider.setTheme(selectedFlutterTheme);

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WaterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HydroPing', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Today', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('${provider.glassesToday} / ${provider.dailyGoal}', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.local_drink),
              label: const Text('+ Glass'),
              onPressed: provider.glassesToday < provider.dailyGoal ? provider.addGlass : null,
            ),
          ],
        ),
      ),
    );
  }
}

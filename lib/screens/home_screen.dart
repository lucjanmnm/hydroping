import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import 'settings_screen.dart';
import '../widgets/history_chart.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Today', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                    const SizedBox(height: 6),
                    Text('${provider.glassesToday}', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.lightBlue)),
                    Text('of ${provider.dailyGoal} glasses', style: const TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              icon: const Icon(Icons.local_drink),
              label: const Text('Drink a glass'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                elevation: 0,
              ),
              onPressed: provider.glassesToday < provider.dailyGoal ? provider.addGlass : null,
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Last 7 days', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
            ),
            const SizedBox(height: 12),
            const HistoryChart(),
          ],
        ),
      ),
    );
  }
}

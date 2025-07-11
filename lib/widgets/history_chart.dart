import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';

class HistoryChart extends StatelessWidget {
  const HistoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<WaterProvider>().history.reversed.toList();

    if (history.every((e) => e == 0)) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text('No stats yet!', style: TextStyle(color: Colors.grey))),
      );
    }

    final maxY = (history.reduce((a, b) => a > b ? a : b)).toDouble() + 2;

    return SizedBox(
      height: 140,
      child: BarChart(
        BarChartData(
          barGroups: [
            for (int i = 0; i < history.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: history[i].toDouble(),
                    width: 18,
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  const names = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  final int todayWeekday = DateTime.now().weekday;
                  final int index = (v.toInt() + (todayWeekday < 7 ? 7 - todayWeekday : 0)) % 7;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      names[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barTouchData: BarTouchData(enabled: false),
          maxY: maxY,
        ),
      ),
    );
  }
}

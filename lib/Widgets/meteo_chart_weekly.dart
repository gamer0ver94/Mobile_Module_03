import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/Models/weather_model.dart';

class MeteoChartWeekly extends StatefulWidget {
  final Weather weather;
  const MeteoChartWeekly({super.key, required this.weather});

  @override
  State<MeteoChartWeekly> createState() => _MeteoChartWeeklyState();
}

class _MeteoChartWeeklyState extends State<MeteoChartWeekly> {
  @override
  Widget build(BuildContext context) {
    final weather = widget.weather;

    final minY = weather.info
            .map((d) => d["weekly_min_temp"] as num)
            .reduce((a, b) => a < b ? a : b)
            .toDouble() -
        2;

    final maxY = weather.info
            .map((d) => d["weekly_max_temp"] as num)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        2;

    return Card(
      color: const Color.fromARGB(136, 0, 0, 0),
      child: LineChart(
        LineChartData(
          minX: -0.5,
          maxX: 6.5,
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}°C',
                    style: const TextStyle(fontSize: 10,color: Colors.white),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value < 0 || value > 6) return const SizedBox.shrink();
      
                  final day = DateTime.now().add(Duration(days: value.toInt()));
                  return Text(
                    '${day.day}/${day.month}',
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              spots: List.generate(
                7,
                (index) => FlSpot(
                  index.toDouble(),
                  (weather.info[index]["weekly_max_temp"] as num).toDouble(),
                ),
              ),
              dotData: const FlDotData(show: true),
            ),
      
            LineChartBarData(
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              spots: List.generate(
                7,
                (index) => FlSpot(
                  index.toDouble(),
                  (weather.info[index]["weekly_min_temp"] as num).toDouble(),
                ),
              ),
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}

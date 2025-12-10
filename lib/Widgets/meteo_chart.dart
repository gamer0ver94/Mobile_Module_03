import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/Models/weather_model.dart';

class MeteoChart extends StatefulWidget {
  final Weather weather;
  const MeteoChart({super.key, required this.weather});

  @override
  State<MeteoChart> createState() => _MeteoChartState();
}

class _MeteoChartState extends State<MeteoChart> {
  @override
  Widget build(BuildContext context) {
    final Weather weather = widget.weather;

    if (weather.info.isEmpty ||
        weather.info[0]["daily_temp"]["hourly"].isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<num> hourlyTemps =
        List<num>.from(weather.info[0]["daily_temp"]["hourly"]);

    final minY = hourlyTemps.reduce((a, b) => a < b ? a : b).toDouble() - 2;
    final maxY = hourlyTemps.reduce((a, b) => a > b ? a : b).toDouble() + 2;

    final yRange = maxY - minY;
    final yInterval = (yRange / 5).ceilToDouble();

    return Card(
      color: const Color.fromARGB(136, 0, 0, 0),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}°C',
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 3,
                getTitlesWidget: (value, meta) {
                  if (value % 3 != 0) return const SizedBox.shrink();
                  final hour = value.toInt().toString().padLeft(2, '0');
                  return Text(
                    '$hour:00',
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
              barWidth: 3,
              color: Colors.blue,
              spots: List.generate(
                hourlyTemps.length,
                (index) => FlSpot(
                  index.toDouble(),
                  hourlyTemps[index].toDouble(),
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

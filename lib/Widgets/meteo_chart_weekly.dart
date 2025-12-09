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

    // Compute min/max Y with padding
    final minY = weather.info
            .map((d) => d["weekly_min_temp"] as num)
            .reduce((a, b) => a < b ? a : b)
            .toDouble() -
        2; // padding below lowest point

    final maxY = weather.info
            .map((d) => d["weekly_max_temp"] as num)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        2; // padding above highest point

    return LineChart(
      LineChartData(
        minX: -0.5, // padding before first day
        maxX: 6.5,  // padding after last day
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 2,
              getTitlesWidget: (value, meta) {
                // Only show integer temperatures
                return Text(
                  '${value.toInt()}°C',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                // Only show for 0..6
                if (value < 0 || value > 6) return const SizedBox.shrink();

                final day = DateTime.now().add(Duration(days: value.toInt()));
                return Text(
                  '${day.day}/${day.month}', // day/month format
                  style: const TextStyle(fontSize: 10),
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
          // MAX temperature line (red)
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
            dotData: FlDotData(show: true),
          ),

          // MIN temperature line (blue)
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
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

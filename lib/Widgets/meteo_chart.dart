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
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
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
              interval: 3,
              getTitlesWidget: (value, meta) {
                if (value % 3 != 0) return const SizedBox.shrink();

                final hour = value.toInt().toString().padLeft(2, '0');
                return Text(
                  '$hour:00',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
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
              weather.info[0]["daily_temp"]["hourly"].length,
              (index) => FlSpot(
                index.toDouble(),
                (weather.info[0]["daily_temp"]["hourly"][index] as num)
                    .toDouble(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

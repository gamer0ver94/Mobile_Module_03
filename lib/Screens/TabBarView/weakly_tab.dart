import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Widgets/meteo_chart_weekly.dart';

class WeeklyTab extends StatefulWidget {
  final Location location;
  final Weather weather;
  const WeeklyTab({super.key, required this.location, required this.weather});

  @override
  State<WeeklyTab> createState() => _WeeklyTabState();
}

class _WeeklyTabState extends State<WeeklyTab> {
  @override
  Widget build(BuildContext context) {
    Weather weather = widget.weather;
    Location location = widget.location;
    bool isDataAvailable = weather.data['hourly'] != null &&
        weather.data['hourly']['time'] != null &&
        weather.info.isNotEmpty &&
        weather.info[0]['dayly_temp'] != null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(location.city),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(location.state), Text(location.country)],
        ),
        SizedBox(height: 250, child: MeteoChartWeekly(weather: weather)),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(7, (index) {
                  DateTime day = DateTime.now();
                  day = day.add(Duration(days: index));

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("${day.day}/${day.month}"),
                        Icon(Icons.sunny),
                        Text("${weather.info[index]["weekly_max_temp"].toString()}°C max"),
                        Text("${weather.info[index]["weekly_min_temp"].toString()}°C min")
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        )
      ],
    );
  }
}

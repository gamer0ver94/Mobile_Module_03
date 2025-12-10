import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Utils/utils.dart';
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
    if (weather.info.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(
                color: const Color.fromARGB(136, 0, 0, 0),
                child: Column(
                  children: [
                    Text(location.city, style: const TextStyle(color: Colors.blue)),
                    Text("${location.state}, ${location.country}",
                        style: const TextStyle(color: Colors.white))
                  ],
                )),
            SizedBox(height: 250, child: MeteoChartWeekly(weather: weather)),
            Card(
              color: const Color.fromARGB(136, 0, 0, 0),
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
                            Text("${day.day}/${day.month}",
                                style: const TextStyle(color: Colors.white)),
                            Image.asset(
                                getWeatherIconPath(weather.info[0]["cloud"])),
                            Text(weather.info[0]["cloud"],
                                style: const TextStyle(color: Colors.white)),
                            Text(
                                "${weather.info[index]["weekly_max_temp"].toString()}°C max",
                                style: const TextStyle(color: Colors.red)),
                            Text(
                                "${weather.info[index]["weekly_min_temp"].toString()}°C min",
                                style: const TextStyle(color: Colors.blue))
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

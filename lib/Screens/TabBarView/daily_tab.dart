import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Utils/utils.dart';
import 'package:weather_app/Widgets/meteo_chart.dart';

class DailyTab extends StatefulWidget {
  final Location location;
  final Weather weather;
  const DailyTab({super.key, required this.location, required this.weather});
  @override
  State<DailyTab> createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {
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
            Column(
              children: [
                Card(
                    color: const Color.fromARGB(136, 0, 0, 0),
                    child: Column(
                      children: [
                        Text(location.city,
                            style: const TextStyle(color: Colors.blue)),
                        Text("${location.state}, ${location.country}",
                            style: const TextStyle(color: Colors.white))
                      ],
                    )),
              ],
            ),
            SizedBox(
                height: 250,
                child: MeteoChart(weather: weather)),
            Card(
              color: const Color.fromARGB(112, 0, 0, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    weather.info[0]["daily_temp"]["hourly"].length,
                    (index) {
                      final hour = (index * 1) % 24;
                      final timeLabel = "${hour.toString().padLeft(2, '0')}:00";

                      final temp =
                          weather.info[0]["daily_temp"]["hourly"][index];
                      final wind = weather.info[0]["wind_speed"];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(timeLabel,
                                style: const TextStyle(color: Colors.white)), // Hour
                            Image.asset(getWeatherIconPath(
                                weather.info[0]["cloud_hourly"][hour])),
                            Text(weather.info[0]["cloud_hourly"][hour],
                                style: const TextStyle(color: Colors.white)),
                            Text("$temp°C",
                                style: const TextStyle(color: const Color.fromARGB(255, 237, 241, 0))),
                            Row(
                              children: [
                                const Icon(Icons.wind_power, color: Colors.blue,),
                                Text(" ${wind[index]}km/h",
                                    style: const TextStyle(color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';
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
    bool isDataAvailable = weather.data['hourly'] != null &&
        weather.data['hourly']['time'] != null &&
        weather.info.isNotEmpty &&
        weather.info[0]['dayly_temp'] != null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(location.city),
            Text("${location.state}, ${location.country}"),
          ],
        ),
        SizedBox(
            height: 250, // finite height
            child: Opacity(
                opacity: 0.5,
                child: Card(child: MeteoChart(weather: weather)))),
        Opacity(
          opacity: 0.5,
          child: Card(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  weather.info[0]["daily_temp"]["hourly"].length,
                  (index) {
                    final hour = (index * 1) % 24;
                    final timeLabel = "${hour.toString().padLeft(2, '0')}:00";
            
                    final temp = weather.info[0]["daily_temp"]["hourly"][index];
                    final wind = weather.info[0]["wind_speed"];
            
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(timeLabel), // Hour
                          const Icon(Icons.sunny),
                          Text("$temp°C"),
                          Text("${wind[index]}km/h")
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

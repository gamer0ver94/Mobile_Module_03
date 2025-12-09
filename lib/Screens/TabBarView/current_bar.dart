import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';

class CurrentBar extends StatefulWidget {
  final Location location;
  final Weather weather;
  const CurrentBar({super.key, required this.location, required this.weather});

  @override
  State<CurrentBar> createState() => _CurrentBarState();
}

class _CurrentBarState extends State<CurrentBar> {
  @override
  Widget build(BuildContext context) {
    Location location = widget.location;
    Weather weather = widget.weather;
    bool isDataAvailable = weather.data.isEmpty ||
        weather.data?['hourly'] != null &&
            weather.data?['hourly']?['time'] != null &&
            weather.info.isNotEmpty &&
            weather.info[0]['dayly_temp'] != null;
    return isDataAvailable
        ? Center(
            child: SizedBox(
              width: 500,
              height: 400,
              child: Opacity(
                opacity: 0.5,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Text(widget.location.city),
                        Text("${location.state}, ${location.country}"),
                      ]),
                      Text("${weather.info[0]["current_temp"].toString()}°C"),
                      Column(children: [
                        Text(weather.info[0]["cloud"]),
                        Icon(
                          Icons.sunny,
                        )
                      ]),
                      Text(
                          "${weather.info[0]["wind_speed"][0].toString()} km/h")
                    ],
                  ),
                ),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }
}

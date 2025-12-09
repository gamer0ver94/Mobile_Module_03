import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Screens/TabBarView/current_bar.dart';
import 'package:weather_app/Screens/TabBarView/daily_tab.dart';
import 'package:weather_app/Screens/TabBarView/weakly_tab.dart';

class WeatherBarView extends StatefulWidget {
  final Location location;
  final Weather weather;
  final TabController controller;
  final String errorMessage;

  const WeatherBarView({super.key, required this.location, required this.weather, required this.controller, required this.errorMessage});

  @override
  State<WeatherBarView> createState() => _WeatherBarViewState();
}

class _WeatherBarViewState extends State<WeatherBarView>
     {


  @override
  Widget build(BuildContext context) {
    Location location = widget.location;
    Weather weather = widget.weather;
    String errorMessage = widget.errorMessage;
    if (errorMessage.isNotEmpty){
      return Text(errorMessage);
    }
    return TabBarView(controller: widget.controller, children: [
      CurrentBar(location: location, weather: weather),
      DailyTab(location: location, weather: weather,),
      WeeklyTab(location: location, weather: weather,)
    ]);
  }
}

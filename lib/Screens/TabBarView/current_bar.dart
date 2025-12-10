import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Utils/utils.dart';

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
    
    if (weather.info.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    for(int i = 0; i < weather.info.length;i++){
      print(weather.info[i]["cloud"]);
    }
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          height: 400,
          child: Card(
            color: const Color.fromARGB(136, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Text(widget.location.city, style: const TextStyle(color: Colors.blue),),
                  Text("${location.state}, ${location.country}", style: const TextStyle(color: Colors.white),),
                ]),
                Text("${weather.info[0]["current_temp"].toString()}°C", style: const TextStyle(color: const Color.fromARGB(255, 189, 170, 1)),),
                Column(children: [
                  Text(weather.info[0]["cloud_hourly"][DateTime.now().hour], style: const TextStyle(color: Colors.white),),
                  Image.asset(getWeatherIconPath(weather.info[0]["cloud_hourly"][DateTime.now().hour]))
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wind_power, color: Colors.blue,),
                    Text("  ${weather.info[0]["wind_speed"][0].toString()} km/h", style: const TextStyle(color: Colors.white),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

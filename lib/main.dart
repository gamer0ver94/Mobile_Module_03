import 'package:flutter/material.dart';
import 'package:weather_app/Screens/weather_app.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return  const WeatherApp();
  }
}

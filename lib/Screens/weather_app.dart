import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Screens/TabBarView/weather_bar_view.dart';
import 'package:weather_app/Screens/SearchBarView/search_app_bar.dart';
import 'package:weather_app/Services/geolocation.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp>
    with SingleTickerProviderStateMixin {
  Location location = Location.empty();
  Weather weather = Weather(data: {});
  String errorMessage = '';
  int currentIndex = 0;
  Future<bool> permission = requestLocationPermission();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    requestGpsLocation();
  }

  void requestGpsLocation() async {
    try {
      Location currentLocation = await updateGeoLocation();
      location = currentLocation;
      if (location.latitude.isNotEmpty) {
        updateWeather();
      }
    } catch (error) {
      errorMessage = error.toString();
    }
  }

  void changeControllerIndex(newIndex) {
    setState(() {
      _tabController.index = newIndex;
    });
  }

  void updateLocation(Location location) {
    setState(() {
      this.location = location;

      updateWeather();
    });
  }

  Future updateWeather() async {
    bool doesExist =
        location.latitude.isNotEmpty && location.longitude.isNotEmpty;
    if (!doesExist) {
      setState(() {
        errorMessage =
            'Could Not find any result for the suplied address or coordinates';
      });

      return [];
    }
    double latitude = double.parse(location.latitude);
    double longitude = double.parse(location.longitude);
    try {
      dynamic data = await fetchWeather(latitude, longitude);
      setState(() {
        weather = Weather(data: data);
        weather.parseWeather();
        errorMessage = '';
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  List<Widget> viewScreen = [
    const Tab(
      text: "Currently",
      icon: const Icon(Icons.north_west_rounded),
    ),
    const Tab(
      text: "Daily",
      icon: const Icon(Icons.view_day_rounded),
    ),
    const Tab(
      text: "Weekly",
      icon: const Icon(Icons.next_week),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)
        )
      ),
        home: Scaffold(
      appBar: SearchAppBar(
        update: updateLocation,
        requestGpsLocation: requestGpsLocation,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover)),
        child: WeatherBarView(
          location: location,
          weather: weather,
          controller: _tabController,
          errorMessage: errorMessage,
        ),
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: viewScreen,
      ),
    ));
  }
}

import 'dart:convert';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Services/fetch_geolocation.dart';
import 'package:weather_app/Services/reverseGeolocation.dart';

Future<Position> getGeolocation() async {
  Position currentPosition;

  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  currentPosition =
      await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  return currentPosition;
}

Future<bool> requestLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  print(permission);
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    print(permission);
    if (permission == LocationPermission.denied) {
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

Future<dynamic> fetchWeather(double latitude, double longitude) async {
  try {
    final response = await http.get(Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=weather_code&hourly=temperature_2m,cloud_cover,wind_speed_10m,weather_code&dayly=weather_code&forecast_days=7&daily=weather_code"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(
          'Failed to fetch weather data, status code: ${response.statusCode}');
      throw Exception('Failed to fetch weather data');
    }
  } catch (error) {
    print('Error fetching weather: $error');
  }
}

Future<List<String>> getGeo(String country, var sugestedCountriesData) async {
  if (country.isEmpty) {
    print("No country name provided!");
    return [];
  }
  try {
    Response res = await fetchGeolocation(country, 20);
    if (country.isEmpty) print("NO COUNTRY NAME");
    // Check if the response status is OK
    if (res.statusCode != 200) {
      throw Exception("Failed to load geo data: ${res.statusCode}");
    }

    // Parse the response body and safely access the "results"
    dynamic body = jsonDecode(res.body);
    dynamic data = body["results"];

    // Ensure data is not null and is a list
    if (data == null || data.isEmpty) {
      throw Exception("No results found or data is null");
    }

    // If data is valid, map it to a list of strings
    List<String> countries = List<String>.from(
      data.map((item) {
        String name = item["name"] ?? "Unknown";
        String admin1 = item["admin1"] ?? "Unknown";
        String country = item["country"] ?? "Unknown";
        return "$name $admin1, $country";
      }),
    );

    // Populate the suggested countries data
    for (int i = 0; i < data.length; i++) {
      sugestedCountriesData[
              "${data[i]["name"]} ${data[i]["admin1"]}, ${data[i]["country"]}"] =
          data[i];
    }

    return countries;
  } catch (error) {
    print("Error occurred in getGeo: $error");
    return [];
  }
}

Future<Location> updateGeoLocation()async{
  Location location;
  try {
      Position geolocation = await getGeolocation();

      dynamic currentLocation =
          await reverseGeocoding(geolocation.latitude, geolocation.longitude);
      currentLocation = currentLocation['address'];
        location = Location(
            city: currentLocation['city'],
            state: currentLocation['state'],
            country: currentLocation['country'],
            latitude: geolocation.latitude.toString(),
            longitude: geolocation.longitude.toString());
      return location;
    } catch (error) {
      throw(Exception('No Permission allowed'));
    }
}
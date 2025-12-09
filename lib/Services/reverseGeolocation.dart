import 'dart:convert';

import 'package:http/http.dart' as http;
Future<dynamic> reverseGeocoding(double latitude, double longitude) async {
  try {
    final response = await http.get(Uri.parse("https://geocode.maps.co/reverse?lat=$latitude&lon=$longitude&api_key=674598d098547640710197qmse3a9cf"));

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print('Failed to fetch reversegeo data, status code: ${response.statusCode}');
      throw Exception('Failed to fetch weather data');
    }
  } catch (error) {
    print('Error fetching rever geo conding: $error');
  }
}

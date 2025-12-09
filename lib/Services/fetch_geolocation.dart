import 'package:http/http.dart' as http;

Future<http.Response> fetchGeolocation(String country, int quantity) async{
  String nameQuantity = quantity.toString();
  String link = 'https://geocoding-api.open-meteo.com/v1/search?name=$country&count=$nameQuantity&language=en&format=json';
  print("LINKI : $link");
  return await http.get(Uri.parse(link));
}
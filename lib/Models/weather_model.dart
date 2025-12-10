import 'package:weather_app/Utils/utils.dart';

class Weather {
  dynamic data;
  dynamic weatherCode = {
    '0': 'Clear Sky',
    '1': 'Mainly Clear',
    '2': 'Partly cloudy',
    '3': 'Overcast',
    '45': 'Fog',
    '48': 'Depositing rime fog',
    '51': 'Light Drizzle',
    '53': 'Moderate Drizzle',
    '55': 'Intense Drizzle',
    '56': 'Light Freezing Drizzle',
    '57': 'Intense Freezing Drizzle',
    '61': 'Slight rain',
    '63': 'Moderate rain',
    '65': 'Intense rain',
    '66': 'Light freezing rain',
    '67': 'Heavy intense freezing rain',
    '71': 'Slight snow fall',
    '73': "Moderate snow fall",
    '75': "Heavy intense snow fall",
    '77': 'Snow grains',
    '80': 'Slight rain showers',
    '81': 'Moderate rain showers',
    '82': 'Heavy intense showers',
    '85': 'Slight snow showers',
    '86': 'Heavy intense showers',
    '95': 'Slight or Moderete Thunderstorm',
    '96': 'Slight thunderstorm and hail',
    '99': 'Heavy Intense thunderstorm and hail',
  };

  dynamic weatherIcons = {};
  List<Map<String, dynamic>> info = [];
  Weather({required this.data});
  void parseWeather() {
    info.clear();
    final List<String> hourlyTimes =
        List<String>.from(data['hourly']['time'] as List);
    final List<num> hourlyTemps =
        List<num>.from(data['hourly']['temperature_2m'] as List);
    final List<num> hourlyWind = data['hourly'].containsKey('wind_speed_10m')
        ? List<num>.from(data['hourly']['wind_speed_10m'] as List)
        : <num>[];

    final List<String> dailyDates =
        List<String>.from(data['daily']['time'] as List);
    final int daysToParse = dailyDates.length < 7 ? dailyDates.length : 7;

    for (int i = 0; i < daysToParse; i++) {
      final DateTime dayDate = DateTime.parse(dailyDates[i]);

      final List<num> dailyTemps = <num>[];
      final List<num> dailyWinds = <num>[];

      for (int h = 0; h < hourlyTimes.length; h++) {
        final DateTime hourDate = DateTime.parse(hourlyTimes[h]);
        if (hourDate.year == dayDate.year &&
            hourDate.month == dayDate.month &&
            hourDate.day == dayDate.day) {
          if (h < hourlyTemps.length) dailyTemps.add(hourlyTemps[h]);
          if (h < hourlyWind.length) dailyWinds.add(hourlyWind[h]);
        }
      }

      if (dailyTemps.isEmpty && hourlyTemps.isNotEmpty) {
        final int start = i * 24;
        for (int k = 0; k < 24 && (start + k) < hourlyTemps.length; k++) {
          dailyTemps.add(hourlyTemps[start + k]);
          if ((start + k) < hourlyWind.length) {
            dailyWinds.add(hourlyWind[start + k]);
          }
        }
      }

      info.add({
        "current_temp": dailyTemps.isNotEmpty
            ? (hourlyTemps.isNotEmpty ? hourlyTemps[DateTime.now().hour] : 0)
            : dailyTemps.first,

        "dayly_temp": dailyTemps,
        "daily_temp": {"hourly": dailyTemps},
        "cloud": weatherCode[data["daily"]["weather_code"][i].toString()],
        "cloud_hourly": [
          for (int j = 0; j < 24; j++)
            weatherCode[
                    data["hourly"]["weather_code"][(i * 24) + j].toString()] ??
                "Unknown"
        ],
        "wind_speed": dailyWinds,
        "weekly_min_temp": getMinimumTemp(data, i),
        "weekly_max_temp": getMaximumTemp(data, i),
      });
    }
  }
}

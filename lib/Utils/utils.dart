double getMinimumTemp(dynamic data, int index) {
  int start = index * 24;
  int end = start + 24;

  double minTemp = data['hourly']['temperature_2m'][start];

  for (int i = start; i < end; i++) {
    double temp = data['hourly']['temperature_2m'][i];
    if (temp < minTemp) {
      minTemp = temp;
    }
  }
  return minTemp;
}

double getMaximumTemp(dynamic data, int index) {
  double maxMemp = 0;
  for (int i = index * 24; i < index * 24 + 24; i++) {
    if (data['hourly']['temperature_2m'][i] > maxMemp) {
      maxMemp = data['hourly']['temperature_2m'][i];
    }
  }
  return maxMemp;
}

String getWeatherIconPath(String condition) {
  if (condition.toLowerCase().contains("clear sky")) {
    return "assets/clear_sky.png";
  } else if (condition.toLowerCase().contains("partly cloudy") ||
      condition.toLowerCase().contains("overcast") ||
      condition.toLowerCase().contains("mainly clear")) {
    return "assets/mainly_clear.png";
  } else if (condition.toLowerCase().contains("fog")) {
    return "assets/fog.png";
  } else if (condition.toLowerCase().contains("rain")) {
    return "assets/rain.png";
  } else if (condition.toLowerCase().contains("snow")) {
    return "assets/rain.png";
  } else if (condition.toLowerCase().contains("thunderstorm")) {
    return "assets/thunderstorm.png";
  }
  else if (condition.toLowerCase().contains("drizzle")){
    return "assets/drizzle.png";
  }
  else if (condition.toLowerCase().contains("snow")){
    return "assets/snow_rain.png";
  }
  else if (condition.toLowerCase().contains("freezing rain")){
    return "assets/freezing_rain.png";
  }
  else if (condition.toLowerCase().contains("cloudy")){
    return "assets/cloudy.png";
  }
  return "assets/notfound.png";
}

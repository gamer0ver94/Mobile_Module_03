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

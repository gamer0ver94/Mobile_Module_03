

class Location {
  String city;
  String state;
  String country;
  String latitude;
  String longitude;
  Location({
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
  factory Location.empty() {
    return Location(
      city: '',
      state: '',
      country: '',
      latitude: '',
      longitude: '',
    );
  }
}

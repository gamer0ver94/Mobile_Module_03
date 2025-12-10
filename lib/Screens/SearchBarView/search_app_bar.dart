import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Services/geolocation.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(Location) update;
  final Function() requestGpsLocation;

  const SearchAppBar({
    super.key,
    required this.update,
    required this.requestGpsLocation,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _SearchAppBarState extends State<SearchAppBar> {
  var sugestedCountriesData = {};
  List<String> countriesSuggestion = [];
  TextEditingController controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void searchLocations(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }

    List results = await getGeo(query, sugestedCountriesData);
    countriesSuggestion = List<String>.from(results.take(5));

    if (countriesSuggestion.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 16,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: countriesSuggestion.map((fullName) {
                String city = fullName.split(" ")[0];
                String rest = fullName.substring(city.length);

                return ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: city,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: rest,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => selectLocation(fullName),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void selectLocation(String name) {
    if (!sugestedCountriesData.containsKey(name)) return;

    final location = Location(
      city: sugestedCountriesData[name]['name'],
      state: sugestedCountriesData[name]['admin1'],
      country: sugestedCountriesData[name]['country'],
      latitude: sugestedCountriesData[name]['latitude'].toString(),
      longitude: sugestedCountriesData[name]['longitude'].toString(),
    );

    widget.update(location);
    controller.clear();
    _removeOverlay();
  }

  @override
  void dispose() {
    _removeOverlay();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: CompositedTransformTarget(
                    link: _layerLink,
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search location...',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Color.fromARGB(255, 41, 41, 41),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => searchLocations(value),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.location_pin, color: Colors.white),
                  onPressed: () => widget.requestGpsLocation(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

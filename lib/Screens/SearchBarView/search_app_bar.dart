import 'package:flutter/material.dart';
import 'package:weather_app/Models/location_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Services/geolocation.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(Location) update;
  final Function() requestGpsLocation;
  const SearchAppBar({super.key, required this.update, required this.requestGpsLocation});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  var sugestedCountriesData = {};
  List<String> countriesSuggestion = [];
  Location location = Location.empty();
  Weather weatherData = Weather(data: []);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: DefaultTabController(
            length: 2,
            child: TabBar(
                tabAlignment: TabAlignment.fill,
                dividerHeight: 100,
                indicator: const BoxDecoration(color: Colors.transparent),
                indicatorColor: Colors.red,
                tabs: [
                  Tab(
                    child: Autocomplete<String>(optionsBuilder:
                        (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text.isEmpty) {
                        return [];
                      } else {
                        List test = await getGeo(
                            textEditingValue.text, sugestedCountriesData);
                        List countriesList = [];
                        countriesList = test;
                        countriesSuggestion = List<String>.from(
                            countriesList.map((item) => item));
                        return countriesSuggestion;
                      }
                    }, onSelected: (String selected) async {
                      try {
                        location = Location(
                          city: sugestedCountriesData[selected]['name'],
                          state: sugestedCountriesData[selected]['admin1'],
                          country: sugestedCountriesData[selected]['country'],
                          latitude: sugestedCountriesData[selected]['latitude']
                              .toString(),
                          longitude: sugestedCountriesData[selected]
                                  ['longitude']
                              .toString(),
                        );
                        widget.update(location);
                      } catch (error) {
                        print('on Select there was an error $error');
                      }
                    }, fieldViewBuilder:
                        (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        onTap: () => {controller.clear(), controller.text = ''},
                        onSubmitted: (value) async => {
                          if (countriesSuggestion.isNotEmpty)
                            {
                              location = Location(
                                city: sugestedCountriesData[countriesSuggestion[0]]['name'],
                                state: sugestedCountriesData[countriesSuggestion[0]]['admin1'],
                                country: sugestedCountriesData[countriesSuggestion[0]]['country'],
                                latitude: sugestedCountriesData[countriesSuggestion[0]]['latitude']
                                    .toString(),
                                longitude: sugestedCountriesData[countriesSuggestion[0]]['longitude']
                                    .toString(),
                              ),
                              
                              widget.update(location),
                              controller.clear(),
                              controller.text = ''
                            }
                          else
                            {
                             widget.update(Location.empty())
                            }
                        },
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Search location ...',
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                  Tab(
                    child: IconButton(
                        icon: const Icon(
                          Icons.location_pin,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          widget.requestGpsLocation();
                        }),
                  )
                ])),
      ),
    );
  }
}

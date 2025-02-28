import 'package:flutter/material.dart';

enum Station {
  downtownGrounds,
  igniteGrill,
  igniteExhibition,
  streetFare,
  trueBalance,
  ucVegEntree,
  ucVegLto,
  ucVegSaladBar,
  halal
}

enum FoodPreference {
  lowCarbon,
  glutenFree,
  vegan,
  vegetarian,
  wholeGrain,
  eatWell,
  plantForward,
  none
}

class FoodFilterDrawer extends StatefulWidget {
  const FoodFilterDrawer({super.key});

  @override
  State<FoodFilterDrawer> createState() => _FoodFilterDrawerState();
}

class _FoodFilterDrawerState extends State<FoodFilterDrawer> {
  Set<Station> stationFilters = <Station>{};
  Set<FoodPreference> foodPreferenceFilters = <FoodPreference>{};

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 1 / 3,
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Select a station', style: Theme.of(context).textTheme.titleMedium),
                Wrap(
                  spacing: 5.0,
                  children: Station.values.map((Station stationName) {
                    return FilterChip(
                      label: Text(stationName.name),
                      selected: stationFilters.contains(stationName),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            stationFilters.add(stationName);
                          } else {
                            stationFilters.remove(stationName);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10.0),
                Text('Food Preference', style: Theme.of(context).textTheme.titleMedium),
                Wrap(
                  spacing: 5.0,
                  children: FoodPreference.values.map((FoodPreference preference) {
                    return FilterChip(
                      label: Text(preference.name),
                      selected: foodPreferenceFilters.contains(preference),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            foodPreferenceFilters.add(preference);
                          } else {
                            foodPreferenceFilters.remove(preference);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

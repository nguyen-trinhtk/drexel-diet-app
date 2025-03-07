import 'package:flutter/material.dart';

Set<Station> stationFilters = <Station>{};
Set<FoodPreference> foodPreferenceFilters = <FoodPreference>{};

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
  plantForward
}

class FoodFilterDrawer extends StatefulWidget {
  const FoodFilterDrawer({super.key});

  @override
  State<FoodFilterDrawer> createState() => _FoodFilterDrawerState();
}

//Selected choices are in the stationFilters and foodPreferenceFilters sets :)

class _FoodFilterDrawerState extends State<FoodFilterDrawer> {
  String formatText(String text) {
    return text.replaceAllMapped(RegExp(r'([A-Z])'), (Match match) => ' ${match.group(0)}').trim().replaceFirstMapped(RegExp(r'^[a-z]'), (Match match) => match.group(0)!.toUpperCase());
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20.0),
        Text('Station Preference',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 20.0),
        Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          children: Station.values.map((Station stationName) {
            return FilterChip(
              label: Text(formatText(stationName.name)),
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
        const SizedBox(height: 20.0),
        Text('Food Preference', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 20.0),
        Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          children: FoodPreference.values.map((FoodPreference preference) {
            return FilterChip(
              label: Text(formatText(preference.name)),
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
        const SizedBox(height: 20.0),
        Text(
          'Selected Stations: ${stationFilters.map((e) => formatText(e.name)).join(', ')}',
        ),
        const SizedBox(height: 20.0),
        Text(
          'Selected Food Preferences: ${foodPreferenceFilters.map((e) => formatText(e.name)).join(', ')}',
        ),
      ],
    );
  }
}

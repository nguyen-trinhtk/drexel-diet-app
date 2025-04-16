import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UI/colors.dart';
import '../UI/custom_text.dart';

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
  State<FoodFilterDrawer> createState() => FoodFilterDrawerState();
}

class FoodFilterDrawerState extends State<FoodFilterDrawer>
    with ChangeNotifier {
  String formatText(String text) {
    return text
        .replaceAllMapped(
            RegExp(r'([A-Z])'), (Match match) => ' ${match.group(0)}')
        .trim()
        .replaceFirstMapped(
            RegExp(r'^[a-z]'), (Match match) => match.group(0)!.toUpperCase());
  }

@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: CustomText(
                content: 'Filters',
                fontSize: 20,
                header: true,
                bold: true,
                underline: true,
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: CustomText(
                content: 'Station Preferences',
                fontSize: 16,
                bold: true,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: Station.values.map((Station stationName) {
                return FilterChip(
                  showCheckmark: false,
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.accent,
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
                  label: CustomText(
                    content: formatText(stationName.name),
                    fontSize: 12,
                    color: stationFilters.contains(stationName)
                        ? AppColors.white
                        : AppColors.accent,
                    bold: true,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: AppColors.accent,
                      width: 1,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: CustomText(
                content: 'Food Preferences',
                fontSize: 16,
                bold: true,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: FoodPreference.values.map((FoodPreference preference) {
                return FilterChip(
                  showCheckmark: false,
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.accent,
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
                  label: CustomText(
                    content: formatText(preference.name),
                    fontSize: 12,
                    color: foodPreferenceFilters.contains(preference)
                        ? AppColors.white
                        : AppColors.accent,
                    bold: true,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: AppColors.accent,
                      width: 1,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<FoodFilterDrawerState>().notifyListeners();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppColors.primaryText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: CustomText(
                      content: 'Apply Filters',
                      header: true,
                      fontSize: 12,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        stationFilters.clear();
                        foodPreferenceFilters.clear();
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: AppColors.primaryText,
                          width: 1,
                        ),
                      ),
                    ),
                    child: CustomText(
                      content: '    Reset    ',
                      fontSize: 12,
                      header: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 20,
        right: 20,
        child: IconButton(
          icon: const Icon(Icons.close),
          iconSize: 20,
          onPressed: () => Navigator.pop(context),
          color: AppColors.primaryText,
        ),
      ),
    ],
  );
}

}

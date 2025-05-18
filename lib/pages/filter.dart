import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code/themes/constants.dart';
import 'package:code/data_provider.dart';
import 'package:code/themes/widgets.dart';


Set<FoodPreference> foodPreferenceFilters = <FoodPreference>{};

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

class FoodFilterDrawerState extends State<FoodFilterDrawer> with ChangeNotifier {
  late RangeValues _currentRangeValues;
  late double lowerBound;
  late double upperBound;

  @override
  void initState() {
    super.initState();
    // Accessing minCalories and maxCalories from GlobalDataProvider
    final globalData = Provider.of<GlobalDataProvider>(context, listen: false);
    lowerBound = globalData.minCalories;
    upperBound = globalData.maxCalories;
    _currentRangeValues = RangeValues(lowerBound, upperBound);
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    // Accessing globalData to update values on build
    final globalData = Provider.of<GlobalDataProvider>(context);

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
                  content: 'Calorie Range',
                  fontSize: 16,
                  header: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    content: 'Lower: ${lowerBound.toInt()}',
                    fontSize: 12,
                    bold: true,
                  ),
                  CustomText(
                    content: 'Upper: ${upperBound.toInt()}',
                    fontSize: 12,
                    bold: true,
                  ),
                ],
              ),
              RangeSlider(
                values: _currentRangeValues,
                activeColor: AppColors.accent,
                inactiveColor: AppColors.secondaryBackground,
                min: globalData.minCalories,
                max: globalData.maxCalories,
                divisions: (globalData.maxCalories - globalData.minCalories).toInt(),
                onChanged: (RangeValues values) {
                  setState(() {
                    lowerBound = values.start
                        .clamp(globalData.minCalories, globalData.maxCalories);
                    upperBound = values.end
                        .clamp(globalData.minCalories, globalData.maxCalories);
                    _currentRangeValues = RangeValues(lowerBound, upperBound);
                  });
                },
              ),
              const SizedBox(height: 40),
              Container(
                height: 40,
                alignment: Alignment.center,
                child: CustomText(
                  content: 'Food Preferences',
                  fontSize: 16,
                  header: true,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children:
                    FoodPreference.values.map((FoodPreference preference) {
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
              const SizedBox(height: 80),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<FoodFilterDrawerState>().notifyListeners();
                      },
                      padding: const EdgeInsets.all(10),
                      text: 'Apply Filters',
                      header: true,
                      fontSize: 12,
                      textColor: AppColors.white,
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          foodPreferenceFilters.clear();
                          lowerBound = globalData.minCalories;
                          upperBound = globalData.maxCalories;
                          _currentRangeValues =
                              RangeValues(lowerBound, upperBound);
                        });
                      },
                      padding: const EdgeInsets.all(10),
                      color: AppColors.white,
                      borderColor: AppColors.primaryText,
                      hoverColor: AppColors.tertiaryText,
                      textColor: AppColors.primaryText,
                      text: '    Reset    ',
                      fontSize: 12,
                      header: true,
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

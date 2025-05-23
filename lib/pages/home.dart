import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'filter.dart';
import 'package:code/themes/constants.dart';
import 'package:code/themes/widgets.dart';
import 'package:code/user-data/meals.dart';
import 'package:code/data_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  bool isLogBarExpanded = false;
  final Map<String, Map<String, dynamic>> _loggedDishes = {};
  int _totalCalories = 0;
  int _totalCarbs = 0;
  int _totalFat = 0;
  int _totalProtein = 0;
  
  @override
  void initState() {
    super.initState();
    loadJsonAsset('urban');
  }

  Future<void> loadJsonAsset(String filename) async {
    final globalData = Provider.of<GlobalDataProvider>(context, listen: false);
    final String jsonString =
        await rootBundle.loadString('lib/backend/webscraping/$filename.json');
    final data = jsonDecode(jsonString);
    if (filename == 'urban') {
      globalData.setMenuData(data);
    }
  }

  int findCardsPerRow(double viewWidth, double minCardWidth) {
    return viewWidth ~/ minCardWidth;
  }

  void appendLog(
      String foodName, int calories, int protein, int carbs, int fat) {
    final previous = Map<String, dynamic>.from(_loggedDishes[foodName] ?? {});
    final previousQuantity = previous['quantity'] ?? 0;
    final previousNutritions = Map<String, int>.from(previous['nutritions'] ??
        {
          'calories': 0,
          'protein': 0,
          'carbs': 0,
          'fat': 0,
        });

    final newQuantity = previousQuantity + 1;
    final newNutritions = {
      'calories': previousNutritions['calories']! + calories,
      'protein': previousNutritions['protein']! + protein,
      'carbs': previousNutritions['carbs']! + carbs,
      'fat': previousNutritions['fat']! + fat,
    };

    setState(() {
      _loggedDishes[foodName] = {
        'quantity': newQuantity,
        'nutritions': newNutritions,
      };
      _totalCalories += calories;
      _totalProtein += protein;
      _totalCarbs += carbs;
      _totalFat += fat;
    });
  }

  void logMeal() {
    final globalData = Provider.of<GlobalDataProvider>(context, listen: false);
    final mealsProvider = Provider.of<MealsProvider>(context, listen: false);

    final now = DateTime.now();
    final _date =
        "${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}";
    final _time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    final _name = now.hour >= 16
        ? "Dinner"
        : now.hour >= 11
            ? "Lunch"
            : "Breakfast";

    final loggedCopy = Map<String, Map<String, dynamic>>.from(_loggedDishes);
    final entry = {
      "name": _name,
      "date": _date,
      "time": _time,
      "totalCalories": _totalCalories,
      "totalProtein": _totalProtein,
      "totalCarbs": _totalCarbs,
      "totalFat": _totalFat,
      "dishes": loggedCopy,
    };

    mealsProvider.updateDailyTotalCalories(
        mealsProvider.dailyTotalCalories + _totalCalories);
    mealsProvider.updateDailyTotalProtein(
        mealsProvider.dailyTotalProtein + _totalProtein);
    mealsProvider
        .updateDailyTotalCarbs(mealsProvider.dailyTotalCarbs + _totalCarbs);
    mealsProvider.updateDailyTotalFat(mealsProvider.dailyTotalFat + _totalFat);

    globalData.addMealEntry(entry); // Updated to add directly to a list

    setState(() {
      _resetLog();
    });
  }

  void _resetLog() {
    _loggedDishes.clear();
    _totalCalories = 0;
    _totalCarbs = 0;
    _totalProtein = 0;
    _totalFat = 0;
  }

  List<Widget> get logBarCards {
    return _loggedDishes.entries.map((entry) {
      return FoodItemInfo(
        foodName: entry.key,
        quantity: entry.value['quantity'],
        nutritionInfo: entry.value['nutritions'],
      );
    }).toList();
  }

  Map<dynamic, dynamic> getRecommendedMenu(){
    Map<dynamic, dynamic> recommendedMenu = {"0":
	{
		"Name": "Tater Tots",
		"Description": "Deep-fried seasoned shredded potato bites",
		"Calories": "190",
		"totalFat": "10 g",
		"saturatedFat": "1.5 g",
		"transFat": "0 g",
		"cholesterol": "0 mg",
		"sodium": "530 mg",
		"totalCarbohydrates": "24 g",
		"dietaryFiber": "2 g",
		"totalSugars": "1 g",
		"addedSugars": "0 g",
		"protein": "2 g",
		"vegan": "True",
		"eatWell": "False",
		"plantForward": "False",
		"vegetarian": "False",
		"lowCarbon": "False",
		"glutenFree": "True"
	}};
    return recommendedMenu;
  }

  @override
  Widget build(BuildContext context) {
    final globalData = context.watch<GlobalDataProvider>();
    final viewWidth = MediaQuery.of(context).size.width;
    context.watch<FoodFilterDrawerState>();
    
    Map<dynamic, dynamic> recommendedMenu = {};
    recommendedMenu = getRecommendedMenu();

    Map<dynamic, dynamic> filteredMenu = {};
    final menuData = globalData.menuData;

    if (lowerBound == 0 && upperBound == 0 && globalData.maxCalories != 0) {
      lowerBound = globalData.minCalories;
      upperBound = globalData.maxCalories;
    }

    var indexNum = 0;
    menuData.forEach((index, item) {
      bool passedPref = true;
      for (FoodPreference preference in foodPreferenceFilters) {
          if (item[preference.name] == "False") {
            passedPref = false;
            break;
          }
      }

      int calories = int.tryParse(item["Calories"]) ?? 0;
      if (lowerBound <= calories && calories <= upperBound && passedPref) { 
        filteredMenu[indexNum.toString()] = item;
        indexNum += 1;
      }
      });

    
    return Row(
      children: [
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryBackground,
              scrolledUnderElevation: 0,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*0.02),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.06,
                  child:SearchBar(
                  hintText: "Search",
                  hintStyle: WidgetStateProperty.all(TextStyle(
                    color: AppColors.secondaryText,
                    fontFamily: AppFonts.headerFont,
                  )),
                  textStyle: WidgetStateProperty.all(TextStyle(
                    color: AppColors.primaryText,
                    fontFamily: AppFonts.headerFont,
                  )),
                  backgroundColor: WidgetStateProperty.all(AppColors.white),
                  overlayColor:
                      WidgetStateProperty.all(AppColors.transparentWhite),
                  autoFocus: false,
                  elevation: WidgetStateProperty.all(0),
                  leading: Icon(Icons.search, color: AppColors.primaryText),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      side:
                          BorderSide(color: AppColors.primaryText, width: 1.0),
                      borderRadius: BorderRadius.circular(100))),
                )),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.015),
                  child: CustomButton(
                    text: "Filters",
                    bold: true,
                    height: MediaQuery.of(context).size.height*0.045,
                    fontSize: 20,
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                                color: AppColors.primaryText, width: 1.5),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: FoodFilterDrawer(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Collapsible Log Dish Bar
                IconButton(
                  icon: Icon(
                    isLogBarExpanded ? Icons.close : Icons.menu,
                    color: AppColors.primaryText,
                  ),
                  tooltip: isLogBarExpanded
                      ? "Close Logged Dishes"
                      : "Show Logged Dishes",
                  onPressed: () {
                    setState(() {
                      isLogBarExpanded = !isLogBarExpanded;
                    });
                  },
                ),
                SizedBox(width: MediaQuery.of(context).size.width*0.015),
              ],
            ),
            backgroundColor: AppColors.primaryBackground,
            body: Padding(
              padding: EdgeInsets.all(isLogBarExpanded ? MediaQuery.of(context).size.height*0.015 : MediaQuery.of(context).size.height*0.03),
              child: SingleChildScrollView(
                child: Column(
                spacing: 15,
                children: [
                  // Recommended Food Box
                  Container(
                    // Check if there is recommended food
                    child: recommendedMenu.isEmpty ? null : 
                    Container(
                  decoration: BoxDecoration(
                  color:AppColors.secondaryBackground, borderRadius: BorderRadius.circular(40)),
                  padding: EdgeInsets.all(16),
                  child: GridView.builder(
                    
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: findCardsPerRow(viewWidth, 350),
                  crossAxisSpacing: MediaQuery.of(context).size.height*0.02,
                  mainAxisSpacing: MediaQuery.of(context).size.width*0.01,
                  childAspectRatio: isLogBarExpanded ? 1.2 : 1.4,
                ),
                itemCount: recommendedMenu.length,
                itemBuilder: (context, index) {
                  final strIndex = index.toString();
                  final item = recommendedMenu?[strIndex];
                  if (item == null) return const SizedBox();

                  final foodName = item['Name'];
                  final calories = int.tryParse(item['Calories']) ?? 0;
                  final protein = int.tryParse(
                          item['protein']?.replaceAll(RegExp(r'[^\d]'), '') ??
                              '0') ??
                      0;
                  final carbs = int.tryParse(item['totalCarbohydrates']
                              ?.replaceAll(RegExp(r'[^\d]'), '') ??
                          '0') ??
                      0;
                  final fat = int.tryParse(
                          item['totalFat']?.replaceAll(RegExp(r'[^\d]'), '') ??
                              '0') ??
                      0;

                  return FoodCard(
                    name: foodName,
                    description: item['Description'],
                    calories: "Calories $calories",
                    fontSize: isLogBarExpanded ? 14 : 18,
                    onAddPressed: () {
                      appendLog(foodName, calories, protein, carbs, fat);
                      setState(() => isLogBarExpanded = true);
                    },
                  );
                },
                  )
                    )
                    )
              ,
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: findCardsPerRow(viewWidth, 350),
                  crossAxisSpacing: MediaQuery.of(context).size.height*0.02,
                  mainAxisSpacing: MediaQuery.of(context).size.width*0.01,
                  childAspectRatio: isLogBarExpanded ? 1.2 : 1.4,
                ),
                itemCount: filteredMenu?.length,
                itemBuilder: (context, index) {
                  final strIndex = index.toString();
                  final item = filteredMenu?[strIndex];
                  if (item == null) return const SizedBox();

                  final foodName = item['Name'];
                  final calories = int.tryParse(item['Calories']) ?? 0;
                  final protein = int.tryParse(
                          item['protein']?.replaceAll(RegExp(r'[^\d]'), '') ??
                              '0') ??
                      0;
                  final carbs = int.tryParse(item['totalCarbohydrates']
                              ?.replaceAll(RegExp(r'[^\d]'), '') ??
                          '0') ??
                      0;
                  final fat = int.tryParse(
                          item['totalFat']?.replaceAll(RegExp(r'[^\d]'), '') ??
                              '0') ??
                      0;

                  return FoodCard(
                    name: foodName,
                    description: item['Description'],
                    calories: "Calories $calories",
                    fontSize: isLogBarExpanded ? 14 : 18,
                    onAddPressed: () {
                      appendLog(foodName, calories, protein, carbs, fat);
                      setState(() => isLogBarExpanded = true);
                    },
                  );
                },
              )
              ]
              ),
              )
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width:
              isLogBarExpanded ? MediaQuery.of(context).size.width * 0.225 : 0,
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
          ),
          child: isLogBarExpanded
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*0.02),
                  child: Column(
                    spacing: MediaQuery.of(context).size.height*0.01,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: CustomText(
                              content: 'Dishes', fontSize: 24, header: true)),
                      Container(height: 2, color: AppColors.primaryText),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
                          color: AppColors.white,
                          width: double.infinity,
                          child: Scrollbar(
                            thumbVisibility: false,
                            child: SingleChildScrollView(
                                child: Column(children: logBarCards)),
                          ),
                        ),
                      ),
                      Container(height: 2, color: AppColors.primaryText),
                      ...[
                        ['Calories', _totalCalories],
                        ['Protein', _totalProtein],
                        ['Carbs', _totalCarbs],
                        ['Fat', _totalFat],
                      ].map((e) => Row(
                            children: [
                              Expanded(
                                  child: CustomText(
                                      content: e[0] as String,
                                      fontSize: 14,
                                      header: true)),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width*0.05,
                                  child: CustomText(
                                      content: e[1].toString(),
                                      fontSize: 14,
                                      header: true)),
                            ],
                          )),
                      Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom:MediaQuery.of(context).size.height*.01),
                            child:CustomButton(
                              text: "Log Meal", onPressed: logMeal)),
                      )
                    ],
                  ),
                )
              : null,
        ),
      ],
    );
  }
}

import 'package:code/UI/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'filter.dart';
import '../UI/colors.dart';
import '../backend/meals.dart';
import '../UI/custom_elements.dart';
import '../UI/widgets.dart';

Map<String, Map<String, dynamic>> loggedDishes = {};
List<Widget> logBarCards = [];
int totalCalories = 0;
int totalCarbs = 0;
int totalFat = 0;
int totalProtein = 0;
int mealIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  bool isLogBarExpanded = false;
  Map<String, Map<dynamic, dynamic>> jsonData = {};

  @override
  void initState() {
    super.initState();
    loadJsonAsset('menu');
    // loadJsonAsset('history');
  }

  Future<void> loadJsonAsset(filename) async {
    final String jsonString =
        await rootBundle.loadString('lib/backend/webscraping/$filename.json');
    var data = jsonDecode(jsonString);
    setState(() {
      jsonData[filename] = data;
    });
  }

  int findCardsPerRow(double viewWidth, double minCardWidth) {
    return viewWidth ~/ minCardWidth;
  }

  void appendLog(
      String foodName, int calories, int protein, int carbs, int fat) {
    setState(() {
      if (loggedDishes.containsKey(foodName)) {
        loggedDishes[foodName]!['quantity'] =
            (loggedDishes[foodName]!['quantity'] ?? 0) + 1;
        loggedDishes[foodName]!['nutritions']['calories'] =
            (loggedDishes[foodName]!['nutritions']['calories'] ?? 0) + calories;
        loggedDishes[foodName]!['nutritions']['protein'] =
            (loggedDishes[foodName]!['nutritions']['protein'] ?? 0) + protein;
        loggedDishes[foodName]!['nutritions']['carbs'] =
            (loggedDishes[foodName]!['nutritions']['carbs'] ?? 0) + carbs;
        loggedDishes[foodName]!['nutritions']['fat'] =
            (loggedDishes[foodName]!['nutritions']['fat'] ?? 0) + fat;
      } else {
        loggedDishes[foodName] = {
          'quantity': 1,
          'nutritions': {
            'calories': calories,
            'protein': protein,
            'carbs': carbs,
            'fat': fat,
          }
        };
      }
    });
  }

  void buildLogCards() {
    logBarCards.clear();
    loggedDishes.forEach((key, value) {
      logBarCards.add(FoodItemInfo(
          foodName: key,
          quantity: value['quantity'],
          nutritionInfo: value['nutritions']));
    });
  }

  void updateTotal(int calories, int carbs, int fat, int protein) {
    setState(() {
      totalCalories += calories;
      totalCarbs += carbs;
      totalFat += fat;
      totalProtein += protein;
    });
  }

  void logMeal() {
    setState(() {
      final now = DateTime.now();
      String _date =
          '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year.toString().padLeft(4, '0')}';
      String _time =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      String _name;
      if (now.hour >= 16) {
        _name = "Dinner";
      } else if (now.hour >= 11) {
        _name = "Lunch";
      } else {
        _name = "Breakfast";
      }

      Map<String, Map<String, dynamic>> loggedDishesCopy = {};
      loggedDishes.forEach((key, value) {
        loggedDishesCopy[key] = Map.from(value);
      });

      final entry = <String, dynamic>{
        "name": _name,
        "date": _date,
        "time": _time,
        "totalCalories": totalCalories,
        "totalProtein": totalProtein,
        "totalCarbs": totalCarbs,
        "totalFat": totalFat,
        "dishes": loggedDishesCopy,
      };

      dailyTotalCalories += totalCalories;
      dailyTotalProtein += totalProtein;
      dailyTotalCarbs += totalCarbs;
      dailyTotalFat += totalFat;

      mealHistory[mealIndex.toString()] = entry;
      buildHistoryCards();
      mealIndex += 1;
      resetLog();
    });
  }

  void resetLog() {
    setState(() {
      loggedDishes.clear();
      logBarCards.clear();
      totalCalories = 0;
      totalCarbs = 0;
      totalProtein = 0;
      totalFat = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FoodFilterDrawerState>();

    double viewWidth = MediaQuery.sizeOf(context).width;

    return Row(
      children: [
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.transparentBlack,
              title: Container(
                padding: const EdgeInsets.only(left: 20),
                child: SearchBarTheme(
                  data: SearchBarThemeData(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    elevation: WidgetStateProperty.all(0),
                    side: WidgetStateProperty.all(
                      BorderSide(width: 1, color: AppColors.primaryText),
                    ),
                    constraints:
                        BoxConstraints.expand(width: viewWidth, height: 45),
                  ),
                  child: SearchBar(
                    hintText: "Search",
                    hintStyle: WidgetStateProperty.all(
                      TextStyle(
                        color: AppColors.secondaryText,
                        fontFamily: AppFonts.headerFont,
                      ),
                    ),
                    textStyle: WidgetStateProperty.all(
                      TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: AppFonts.headerFont,
                      ),
                    ),
                    leading: Icon(
                      Icons.search,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  padding: const EdgeInsets.only(right: 26),
                  child: CustomButton(
                    text: "Filters",
                    bold: true,
                    height: 45,
                    fontSize: 20,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                color: AppColors.primaryText,
                                width: 1.5,
                              ),
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: FoodFilterDrawer(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (!isLogBarExpanded)
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: AppColors.primaryText,
                    ),
                    tooltip: isLogBarExpanded
                        ? "Hide Logged Dishes"
                        : "Show Logged Dishes",
                    onPressed: () {
                      setState(() {
                        isLogBarExpanded = !isLogBarExpanded;
                      });
                    },
                  ),
                const SizedBox(width: 16),
              ],
            ),
            backgroundColor: AppColors.primaryBackground,
            body: Padding(
              padding: EdgeInsets.all(isLogBarExpanded ? 15 : 30),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: findCardsPerRow(viewWidth, 350),
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                  childAspectRatio: isLogBarExpanded ? 1.2 : 1.4,
                ),
                itemCount: jsonData['menu']?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  if (jsonData['menu'] == null) return SizedBox();

                  String strIndex = index.toString();
                  final item = jsonData['menu']?[strIndex];
                  if (item == null) return SizedBox();

                  int? calories = int.tryParse(item['Calories']) ?? 0;
                  String foodName = item['Name'];
                  int? protein = int.tryParse(item['protein']
                          .replaceAll(' g', '')
                          .replaceAll('less than ', '')
                          .trim()) ??
                      0;
                  int? carbs = int.tryParse(item['totalCarbohydrates']
                          .replaceAll(' g', '')
                          .replaceAll('less than ', '')
                          .trim()) ??
                      0;
                  int fat = int.tryParse(item['totalFat']
                          .replaceAll(' g', '')
                          .replaceAll('less than ', '')
                          .trim()) ??
                      0;

                  return FoodCard(
                    name: foodName,
                    description: item['Description'],
                    calories: "Calories $calories",
                    fontSize: isLogBarExpanded ? 14 : 18,
                    onAddPressed: () {
                      appendLog(foodName, calories, protein, carbs, fat);
                      buildLogCards();
                      updateTotal(calories, carbs, fat, protein);
                      setState(() {
                        isLogBarExpanded = true;
                      });
                    },
                  );
                },
              ),
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
          child: Stack(
            children: [
              if (isLogBarExpanded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: CustomText(
                          content: 'Dishes',
                          fontSize: 24,
                          header: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        color: AppColors.primaryText,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                          ),
                          width: isLogBarExpanded
                              ? MediaQuery.of(context).size.width * 0.225
                              : 0,
                          child: Scrollbar(
                            thumbVisibility: false,
                            child: SingleChildScrollView(
                              child: Column(
                                children: logBarCards,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        color: AppColors.primaryText,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content: 'Calories',
                              fontSize: 14,
                              header: true,
                            ),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              content: totalCalories.toString(),
                              fontSize: 14,
                              header: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content: 'Protein',
                              fontSize: 14,
                              header: true,
                            ),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              content: totalProtein.toString(),
                              fontSize: 14,
                              header: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content: 'Carbs',
                              fontSize: 14,
                              header: true,
                            ),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              content: totalCarbs.toString(),
                              fontSize: 14,
                              header: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content: 'Fat',
                              fontSize: 14,
                              header: true,
                            ),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              content: totalFat.toString(),
                              fontSize: 14,
                              header: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Column(
                            children: [
                              CustomButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                header: true,
                                onPressed: () => setState(() {
                                  logMeal();
                                  isLogBarExpanded = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Meal Logged!')));
                                }),
                                text: 'Log Meal',
                              ),
                              const SizedBox(height: 10),
                              CustomButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                header: true,
                                color: AppColors.white,
                                borderColor: AppColors.primaryText,
                                hoverColor: AppColors.tertiaryText,
                                textColor: AppColors.primaryText,
                                onPressed: resetLog,
                                text: 'Reset',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              Positioned(
                top: 15,
                left: 15,
                child: IconButton(
                  icon: Icon(
                    isLogBarExpanded
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_back_ios,
                    color: AppColors.primaryText,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      isLogBarExpanded = !isLogBarExpanded;
                    });
                  },
                  style: IconButton.styleFrom(
                    overlayColor: (Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

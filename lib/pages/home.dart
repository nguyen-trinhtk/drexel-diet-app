import 'package:code/UI/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'filter.dart';
import '../UI/colors.dart';
import '../UI/custom_elements.dart';
import '../UI/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  bool isLogBarExpanded = false;
  dynamic jsonData;
  List<Widget> _logBarCards = [];
  int _totalCalories = 0;
  int _totalCarbs = 0;
  int _totalFat = 0;
  int _totalProtein = 0;

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
  }

  Future<void> loadJsonAsset() async {
    final String jsonString =
        await rootBundle.loadString('lib/backend/webscraping/menu.json');
    var data = jsonDecode(jsonString);
    setState(() {
      jsonData = data;
    });
  }

  int findCardsPerRow(double viewWidth, double minCardWidth) {
    return viewWidth ~/ minCardWidth;
  }

  void _appendLog(Widget child) {
    setState(() {
      _logBarCards.add(child);
    });
  }

  void _updateTotal(int calories, int carbs, int fat, int protein) {
    setState(() {
      _totalCalories += calories;
      _totalCarbs += carbs;
      _totalFat += fat;
      _totalProtein += protein;
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
                itemCount: jsonData.length,
                itemBuilder: (BuildContext context, int index) {
                  String strIndex = index.toString();
                  int? calories =
                      int.tryParse(jsonData[strIndex]['Calories']) ?? 0;
                  "Calories ${jsonData[strIndex]['Calories']}";
                  String foodName = jsonData[strIndex]['Name'];
                  int? protein = int.tryParse(jsonData[strIndex]['protein']
                          .replaceAll(' g', '')
                          .replaceAll('less than ', '')
                          .trim()) ??
                      0;
                  int? carbs = int.tryParse(jsonData[strIndex]
                              ['totalCarbohydrates']
                          .replaceAll(' g', '')
                          .replaceAll('less than ', '')
                          .trim()) ??
                      0;
                  int fat = int.tryParse(jsonData[strIndex]['totalFat']
                          .replaceAll(' g', '')
                          .replaceAll('less than ', '')
                          .trim()) ??
                      0;
                  return FoodCard(
                    name: jsonData[strIndex]['Name'],
                    description: jsonData[strIndex]['Description'],
                    calories: "Calories $calories",
                    fontSize: isLogBarExpanded ? 14 : 18,
                    onAddPressed: () {
                      _appendLog(FoodItemInfo(
                          foodName: foodName,
                          quantity: 1,
                          nutritionInfo: {
                            'calories': calories,
                            'protein': protein,
                            'carbs': carbs,
                            'fat': fat,
                          }));
                      _updateTotal(calories, carbs, fat, protein);
                      isLogBarExpanded = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dish Logged')),
                      );
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
                          child: Scrollbar(
                            thumbVisibility: false,
                            child: SingleChildScrollView(
                              child: Column(
                                children: _logBarCards,
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
                              content: _totalCalories.toString(),
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
                              content: _totalProtein.toString(),
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
                              content: _totalCarbs.toString(),
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
                              content: _totalFat.toString(),
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
                                onPressed: () => setState(() {
                                  _logBarCards.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Log Bar Reset!')));
                                }),
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

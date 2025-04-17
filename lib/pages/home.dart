import 'package:code/UI/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'filter.dart';
import '../UI/colors.dart';
import '../UI/custom_text.dart';
import '../UI/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  bool isLogBarExpanded = false;
  var jsonData;

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

  @override
  Widget build(BuildContext context) {
    List<String> foods = [
      "lowCarbon",
      "glutenFree",
      "vegan",
      "vegetarian",
      "wholeGrain",
      "eatWell",
      "plantForward"
    ];

    List<String> filteredFoods = [];
    context.watch<FoodFilterDrawerState>();

    for (FoodPreference filter in foodPreferenceFilters) {
      for (String food in foods) {
        if (filter.name.toString() == food) {
          filteredFoods.add(food);
        }
      }
    }

    if (filteredFoods.isEmpty) {
      filteredFoods = foods;
    }

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
                        color: const Color(0xFFCACAF6),
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
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryText,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: CustomText(
                        content: "Filters",
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
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
              padding: const EdgeInsets.only(top: 30, bottom: 10, left: 30, right: 30),
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
                  String calories =
                      "Calories ${jsonData[strIndex]['Calories']}";
                  bool display = false;

                  for (String food in filteredFoods) {
                    display = true;
                  }

                  if (display) {
                    return FoodCard(
                      name: jsonData[strIndex]['Name'],
                      description: jsonData[strIndex]['Description'],
                      calories: calories,
                      fontSize: isLogBarExpanded ? 14 : 18,
                      onAddPressed: () {
                        setState(() {
                          isLogBarExpanded = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('You got 10% fatter')),
                        );
                      },
                    );
                  } else {
                    return null;
                  }
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                          ),
                          child: Scrollbar(
                            thumbVisibility: false,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  FoodItemInfo(
                                    foodName: 'haiz',
                                    quantity: 1,
                                    nutritionInfo: {
                                      'Calories': 127,
                                      'Carbs': 12,
                                      'Protein': 30,
                                      'Fat': 4,
                                    },
                                  ),
                                  FoodItemInfo(
                                    foodName: 'whatttttt',
                                    quantity: 1,
                                    nutritionInfo: {
                                      'Calories': 50,
                                      'Carbs': 10,
                                      'Protein': 2,
                                      'Fat': 1,
                                    },
                                  ),
                                  FoodItemInfo(
                                    foodName: 'abcdefghijklmnopqrSTFU',
                                    quantity: 1,
                                    nutritionInfo: {
                                      'Calories': 200,
                                      'Carbs': 45,
                                      'Protein': 4,
                                      'Fat': 0.5,
                                    },
                                  ),
                                  FoodItemInfo(
                                    foodName: 'blah blah blah blah blah',
                                    quantity: 1,
                                    nutritionInfo: {
                                      'Calories': 80,
                                      'Carbs': 20,
                                      'Protein': 1,
                                      'Fat': 0.5,
                                    },
                                  ),
                                ],
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
                              content: '999',
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
                              content: '34',
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
                              content: '22',
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
                              content: '17',
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
                          child: TextButton(
                            onPressed: () => setState(() {
                              isLogBarExpanded = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Meal Logged!')));
                            }),
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.primaryText,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: CustomText(
                                content: "Add to meal",
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
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

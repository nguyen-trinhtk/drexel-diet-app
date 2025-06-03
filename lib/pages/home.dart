import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:code/SSO-related/SSO.dart';
import 'dart:convert';
import 'filter.dart';
import 'package:code/themes/constants.dart';
import 'package:code/themes/widgets.dart';
import 'package:code/data_provider.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  var logger = Logger();
  bool isLogBarExpanded = false;
  bool urban = true;
  final Map<String, Map<String, dynamic>> _loggedDishes = {};
  final ValueNotifier<String> hall = ValueNotifier<String>("urban");
  String searchQuery = "";
  Map<dynamic, dynamic> recommendedMenu = {};
  int _totalCalories = 0;
  int _totalCarbs = 0;
  int _totalFat = 0;
  int _totalProtein = 0;

  @override
  void initState() {
    super.initState();
    logger.d(hall.toString());
    loadJsonAsset(hall.value).then((_) {
      getRecommendedMenu();
    });
  }

  Future<void> loadJsonAsset(String filename) async {
    final globalData = Provider.of<FoodDataProvider>(context, listen: false);
    final String jsonString =
        await rootBundle.loadString('lib/backend/webscraping/$filename.json');
    final data = jsonDecode(jsonString);
    if (filename == 'urban' || filename == 'hans') {
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
    String? uid = Provider.of<UserProvider>(context, listen: false).userId;
    if (uid == null) {
      print("Error: User ID is null.");
      return;
    }

    var db = FirebaseFirestore.instance;

    final now = DateTime.now();
    final date =
        "${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}";
    final time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    final name = now.hour >= 16
        ? "Dinner"
        : now.hour >= 11
            ? "Lunch"
            : "Breakfast";

    final loggedCopy = Map<String, Map<String, dynamic>>.from(_loggedDishes);
    final entry = <String, dynamic>{
      "name": name,
      "date": date,
      "time": time,
      "totalCalories": _totalCalories,
      "totalProtein": _totalProtein,
      "totalCarbs": _totalCarbs,
      "totalFat": _totalFat,
      "dishes": loggedCopy,
    };

    db.collection("mealHistory").doc(uid).update({
      "mealHistory": FieldValue.arrayUnion([entry])
    }).onError((e, _) {
      print("Error writing document: $e");
    });
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

  Future<void> getRecommendedMenu() async {
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env["GEMINI_API_KEY"];

    final globalData = Provider.of<FoodDataProvider>(context, listen: false);
    final menuData = globalData.menuData;

    List<String> recommendedIndex = [];
    var userDishes = "Honey BBQ Chicken";

    Gemini.init(apiKey: apiKey ?? "");
    await Gemini.instance.prompt(parts: [
      Part.text(
          'Based on user past data, suggest 1-3 dishes from the current menu data, don\'t suggest overlapping dishes twice (e.g. Only suggest Grilled Chicken Breast once). ONLY output your response with only the ID number of the dish (e.g. 1, 2, 3). Here is user past data: $userDishes. Here is menu data: $menuData'),
    ]).then((value) {
      var ans = value?.output;
      print("Answer from Gemini: $ans");
      recommendedIndex = ans!.trim().split(", ");
      print(recommendedIndex);
    }).catchError((e) {
      print('error ${e}');
    });

    int recommendedMenuIndex = 0;
    for (var index in recommendedIndex) {
      recommendedMenu[recommendedMenuIndex.toString()] = menuData[index];
      recommendedMenuIndex += 1;
    }

    print(recommendedMenu);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final globalData = context.watch<FoodDataProvider>();
    final menuData = globalData.menuData;

    final viewWidth = MediaQuery.of(context).size.width;
    SearchController? _searchAnchorController;
    context.watch<FoodFilterDrawerState>();

    Map<dynamic, dynamic> filteredMenu = {};
    // Apply filters
    var indexNum = 0;
    menuData.forEach((index, item) {
      if (searchQuery == "") {
        // If no filter, automatically passed
        bool passedPref = true;
        bool passedCalorie = true;

        // Check pref filters (if available)
        if (foodPreferenceFilters.isNotEmpty) {
          for (FoodPreference preference in foodPreferenceFilters) {
            if (item[preference.name] == "False") {
              passedPref = false;
              break;
            }
          }
        }

        // Check calorie filters (if available)
        if (!(lowerBound == 0 && upperBound == 0)) {
          int calories = int.tryParse(item["Calories"]) ?? 0;
          if (calories < lowerBound || calories > upperBound) {
            passedCalorie = false;
          }
        }

        // Add to menu if passed filters
        if (passedCalorie && passedPref) {
          filteredMenu[indexNum.toString()] = item;
          indexNum += 1;
        }
      } else {
        if (item != null) {
          if (((item["Name"].contains(searchQuery)) |
                  (item["Name"].toLowerCase().contains(searchQuery))) |
              ((item["Description"].contains(searchQuery)) |
                  (item["Description"].toLowerCase().contains(searchQuery)))) {
            filteredMenu[indexNum.toString()] = item;
            indexNum += 1;
          }
        }
      }
    });

    return Row(
      children: [
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryBackground,
              scrolledUnderElevation: 0,
              title: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).height * 0.06,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.01),
                  child: SearchViewTheme(
                    data: SearchViewThemeData(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(color: AppColors.primaryText)),
                      headerTextStyle: TextStyle(
                          fontFamily: AppFonts.textFont,
                          color: AppColors.primaryText),
                      dividerColor: AppColors.primaryText,
                      backgroundColor: Colors.white,
                    ),
                    child: SearchAnchor(
                      builder:
                          (BuildContext context, SearchController controller) {
                        _searchAnchorController = controller;
                        return SearchBar(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: BorderSide(
                                  width: 1, color: AppColors.primaryText))),
                          elevation: WidgetStateProperty.all(0),
                          controller: controller,
                          padding: WidgetStatePropertyAll<EdgeInsets>(
                              EdgeInsets.only(
                                  left: MediaQuery.of(context).size.height *
                                      0.02)),
                          onTap: () {
                            controller.openView();
                          },
                          onChanged: (_) {
                            controller.openView();
                          },
                          leading:
                              const Icon(Icons.search, color: AppColors.accent),
                          trailing: [
                            IconButton(
                              icon: Icon(Icons.clear, color: AppColors.accent),
                              onPressed: () {
                                _searchAnchorController?.clear();
                              },
                            ),
                          ],
                          textStyle: WidgetStateProperty.all(
                            TextStyle(
                              color: AppColors.primaryText,
                              fontFamily: AppFonts.textFont,
                            ),
                          ),
                        );
                      },
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                        String query = controller.value.text;
                        List<String> suggestions = [];
                        for (int index = 0; index < menuData.length; index++) {
                          final item = menuData[index.toString()];
                          if (item != null) {
                            if (((item["Name"].contains(query)) |
                                    (item["Name"]
                                        .toLowerCase()
                                        .contains(query))) |
                                ((item["Description"].contains(query)) |
                                    (item["Description"]
                                        .toLowerCase()
                                        .contains(query)))) {
                              suggestions
                                  .add(menuData[index.toString()]["Name"]);
                            }
                          }
                        }
                        setState(() {
                          searchQuery = query;
                        });
                        return List<ListTile>.generate(suggestions.length,
                            (int index) {
                          final String item = suggestions[index];
                          return ListTile(
                              title: CustomText(content: item),
                              onTap: () {
                                setState(() {
                                  controller.closeView(item);
                                });
                              });
                        });
                      },
                      viewTrailing: [
                        Builder(builder: (context) {
                          return IconButton(
                            icon: Icon(Icons.clear, color: AppColors.accent),
                            onPressed: () {
                              _searchAnchorController?.clear();
                            },
                          );
                        })
                      ],
                      viewLeading: Builder(
                        builder: (context) {
                          return IconButton(
                            icon:
                                Icon(Icons.arrow_back, color: AppColors.accent),
                            onPressed: () {
                              _searchAnchorController?.closeView("");
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.015),
                  child: CustomButton(
                    text: "Filters",
                    bold: true,
                    height: MediaQuery.of(context).size.height * 0.045,
                    fontSize: 20,
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.01),
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
                if (Provider.of<UserProvider>(context, listen: false).userId !=
                    null)
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.015),
              ],
            ),
            backgroundColor: AppColors.primaryBackground,
            body: Padding(
                padding: EdgeInsets.all(isLogBarExpanded
                    ? MediaQuery.of(context).size.height * 0.015
                    : MediaQuery.of(context).size.height * 0.03),
                child: SingleChildScrollView(
                  child: Column(spacing: 15, children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              hall.value = "urban";
                              loadJsonAsset(hall.value).then((_) {
                                getRecommendedMenu();
                              });
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: hall.value == "urban"
                                      ? const Color.fromARGB(160, 255, 205, 208)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: AppColors.primaryText, width: 1)),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: CustomText(
                                    content: "Urban",
                                    fontSize: 18,
                                    bold: true,
                                  ))),
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: CustomText(content: "|")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                hall.value = "hans";
                                loadJsonAsset(hall.value).then((_) {
                                  getRecommendedMenu();
                                });
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: hall.value == "hans"
                                        ? const Color.fromARGB(
                                            160, 255, 205, 208)
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: AppColors.primaryText,
                                        width: 1)),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: CustomText(
                                        content: "Handschumacher",
                                        fontSize: 18,
                                        bold: true))))
                      ],
                    ),

                    // Recommended Food Box
                    Container(
                        // Check if there is recommended food
                        child: recommendedMenu.isEmpty
                            ? null
                            : Container(
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryBackground,
                                    borderRadius: BorderRadius.circular(40)),
                                padding: EdgeInsets.all(16),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        findCardsPerRow(viewWidth, 350),
                                    crossAxisSpacing:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    mainAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                    childAspectRatio:
                                        isLogBarExpanded ? 1.2 : 1.4,
                                  ),
                                  itemCount: recommendedMenu.length,
                                  itemBuilder: (context, index) {
                                    final strIndex = index.toString();
                                    final item = recommendedMenu[strIndex];
                                    if (item == null) return const SizedBox();

                                    final foodName = item['Name'];
                                    final calories =
                                        int.tryParse(item['Calories']) ?? 0;
                                    final protein = int.tryParse(item['protein']
                                                ?.replaceAll(
                                                    RegExp(r'[^\d]'), '') ??
                                            '0') ??
                                        0;
                                    final carbs = int.tryParse(
                                            item['totalCarbohydrates']
                                                    ?.replaceAll(
                                                        RegExp(r'[^\d]'), '') ??
                                                '0') ??
                                        0;
                                    final fat = int.tryParse(item['totalFat']
                                                ?.replaceAll(
                                                    RegExp(r'[^\d]'), '') ??
                                            '0') ??
                                        0;
                                    return FoodCard(
                                      name: foodName,
                                      description: item['Description'],
                                      calories: "Calories $calories",
                                      fontSize: isLogBarExpanded ? 14 : 18,
                                      onAddPressed: () {
                                        String? uid = Provider.of<UserProvider>(
                                                context,
                                                listen: false)
                                            .userId;
                                        if (uid == null || uid.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: CustomText(
                                                  content:
                                                      "Please log in to add food",
                                                  header: true,
                                                  fontSize: 18,
                                                ),
                                                backgroundColor:
                                                    AppColors.white,
                                                iconColor: AppColors.accent,
                                                actions: [
                                                  CustomButton(
                                                      text: "Log in",
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const SSOPage()),
                                                        );
                                                      },
                                                      color: AppColors.accent,
                                                      hoverColor: AppColors
                                                          .primaryText),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          appendLog(foodName, calories, protein,
                                              carbs, fat);
                                          setState(
                                              () => isLogBarExpanded = true);
                                        }
                                      },
                                    );
                                  },
                                ))),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: findCardsPerRow(viewWidth, 350),
                        crossAxisSpacing:
                            MediaQuery.of(context).size.height * 0.02,
                        mainAxisSpacing:
                            MediaQuery.of(context).size.width * 0.01,
                        childAspectRatio: isLogBarExpanded ? 1.2 : 1.4,
                      ),
                      itemCount: filteredMenu.length,
                      itemBuilder: (context, index) {
                        final strIndex = index.toString();
                        final item = filteredMenu[strIndex];
                        if (item == null) return const SizedBox();

                        final foodName = item['Name'];
                        final calories = int.tryParse(item['Calories']) ?? 0;
                        final protein = int.tryParse(item['protein']
                                    ?.replaceAll(RegExp(r'[^\d]'), '') ??
                                '0') ??
                            0;
                        final carbs = int.tryParse(item['totalCarbohydrates']
                                    ?.replaceAll(RegExp(r'[^\d]'), '') ??
                                '0') ??
                            0;
                        final fat = int.tryParse(item['totalFat']
                                    ?.replaceAll(RegExp(r'[^\d]'), '') ??
                                '0') ??
                            0;

                        return FoodCard(
                          name: foodName,
                          description: item['Description'],
                          calories: "Calories $calories",
                          fontSize: isLogBarExpanded ? 14 : 18,
                          onAddPressed: () {
                            String? uid = Provider.of<UserProvider>(context,
                                    listen: false)
                                .userId;
                            if (uid == null || uid.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: CustomText(
                                      content: "Please log in to add food",
                                      header: true,
                                      fontSize: 18,
                                    ),
                                    backgroundColor: AppColors.white,
                                    iconColor: AppColors.accent,
                                    actions: [
                                      CustomButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          text: 'Return',
                                          bold: true,
                                          borderColor: AppColors.accent,
                                          color: AppColors.white,
                                          textColor: AppColors.accent,
                                          hoverColor: AppColors.tertiaryText),
                                      CustomButton(
                                          text: "Log in",
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SSOPage()),
                                            );
                                          },
                                          color: AppColors.accent,
                                          hoverColor: AppColors.primaryText),
                                    ],
                                  );
                                },
                              );
                            } else {
                              appendLog(
                                  foodName, calories, protein, carbs, fat);
                              setState(() => isLogBarExpanded = true);
                            }
                          },
                        );
                      },
                    )
                  ]),
                )),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.02),
                  child: Column(
                    spacing: MediaQuery.of(context).size.height * 0.01,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: CustomText(
                              content: 'Dishes', fontSize: 24, header: true)),
                      Container(height: 2, color: AppColors.primaryText),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: CustomText(
                                      content: e[1].toString(),
                                      fontSize: 14,
                                      header: true)),
                            ],
                          )),
                      Center(
                        child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * .01),
                            child: CustomButton(
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

import 'package:code/UI/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'filter.dart';
import 'package:getwidget/getwidget.dart';
import '../UI/colors.dart';
import '../UI/custom_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
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
    // if jsondata = null return splash screen
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.transparentBlack,
        // ignore: deprecated_member_use
        title: Container(
          padding: EdgeInsets.only(left: 16),
          child: SearchBarTheme(
            data: SearchBarThemeData(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              elevation: WidgetStateProperty.all(0),
              side: WidgetStateProperty.all(
                BorderSide(width: 1, color: AppColors.primaryText),
              ),
              constraints: BoxConstraints.expand(width: viewWidth, height: 45),
            ),
            child: SearchBar(
              hintText: "Search",
              hintStyle: WidgetStateProperty.all(
                TextStyle(
                  color: Color(0xFFCACAF6),
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
                Icons.search, // Add search icon
                color: AppColors.primaryText,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 26),
            child: TextButton(
              style:
                  TextButton.styleFrom(backgroundColor: AppColors.primaryText),
              child: Container(
                  padding: EdgeInsets.all(8),
                  child: CustomText(
                      content: "Filters", fontSize: 18, color: Colors.white)),
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
        ],
      ),
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                findCardsPerRow(viewWidth, 350), // Number of columns in a row
            crossAxisSpacing: 0, // Space between columns
            mainAxisSpacing: 0, // Space between rows
            childAspectRatio: 1.4, // Adjust width/height ratio
          ),
          itemCount: jsonData.length, // Added item count
          itemBuilder: (BuildContext context, int index) {
            String strIndex = index.toString();
            String calories = "Calories ";
            calories = calories + jsonData[strIndex]['Calories'].toString();
            bool display = false;
            for (String food in filteredFoods) {
              //print(filter);
              //if (jsonData[strIndex][food] == 1) {
              display = true;
              //}
            }
            if (display) {
              return GFCard(
                title: GFListTile(
                  title: Container(
                    padding: EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2.5, color: AppColors.accent))),
                    child: Center(
                        child: CustomText(
                            content: jsonData[strIndex]['Name'],
                            fontSize: 18,
                            header: true,
                            textAlign: TextAlign.center,
                            color: AppColors.accent)),
                  ),
                  subTitle: Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Center(
                          child: CustomText(
                        content: calories,
                        fontSize: 16,
                        header: true,
                        textAlign: TextAlign.center,
                      ))),
                ),
                content: CustomText(
                        content: jsonData[strIndex]['Description'],
                        fontSize: 14,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        ),
                buttonBar: GFButtonBar(children: [
                  GFButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Button pressed!')),
                          ),
                      color: AppColors.accent,
                      disabledColor: AppColors.accent,
                      hoverColor: AppColors.primaryText,
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      text: "Add",
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.textFont,
                          fontSize: 16)),
                ]),
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppColors.primaryText,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
              );
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var jsonData;

  Future<void> loadJsonAsset() async {
    final String jsonString =
        await rootBundle.loadString('lib/backend/webscraping/menu.json');
    var data = jsonDecode(jsonString);
    setState(() {
      jsonData = data;
    });
    //print(jsonData);
  }

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
  }

  int findCardsPerRow(double viewWidth, double minCardWidth) {
    return viewWidth ~/ minCardWidth;
  }
}

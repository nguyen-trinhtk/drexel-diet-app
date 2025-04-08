import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'foodfilter.dart';
import 'package:getwidget/getwidget.dart';
import 'ui.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {

  var jsonData; 
  
  Future<void> loadJsonAsset() async { 
    final String jsonString = await rootBundle.loadString('lib/backend/webscraping/menu.json'); 
    var data = jsonDecode(jsonString);
    setState(() { 
      jsonData = data; 
    }); 
    print(jsonData); 
  } 
  

  loadJsonAsset(); 

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
        if (filter.name.toString() == food){
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
        backgroundColor: Color(0xFFFFECED),
        title: const Text('Menu Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: 1,
                    widthFactor: 0.75,
                    alignment: Alignment.centerRight,
                    child: FoodFilterDrawer(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                findCardsPerRow(viewWidth, 350), // Number of columns in a row
            crossAxisSpacing: 10, // Space between columns
            mainAxisSpacing: 10, // Space between rows
            childAspectRatio: 1.5, // Adjust width/height ratio
          ),
          itemCount: jsonData.length, // Added item count
          itemBuilder: (BuildContext context, int index) {
            String strIndex = index.toString();
            String calories = "Calories: ";
            calories = calories + jsonData[strIndex]['Calories'].toString();
            bool display =  false;
            for (String food in filteredFoods){
              //print(filter);
              if (jsonData[strIndex][food] == 1) {
                display = true;
              }
            }
            if (display) {
              return MealCard(
                title: GFListTile(
                  title: Text(jsonData[strIndex]['Name']),
                ),
                content: Text(calories),
              );
            }
            else {
              return null;
            }
          },
        ),
      ),
    );
  }
}

int findCardsPerRow(double viewWidth, double minCardWidth) {
  return viewWidth ~/ minCardWidth;
}

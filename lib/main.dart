import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'sidebar.dart';
import 'foodfilter.dart';


void main() async => runApp(
  ChangeNotifierProvider(
    create: (context) => FoodFilterDrawerState(),
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var jsonData; 
  
  Future<void> loadJsonAsset() async { 
    final String jsonString = await rootBundle.loadString('lib/backend/webscraping/menu.json'); 
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

  List<String> foods = [
  "lowCarbon",
  "glutenFree",
  "vegan",
  "vegetarian",
  "wholeGrain",
  "eatWell",
  "plantForward"
  ];


  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Color(0xffffbf65),
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
      drawer: Sidebar(),
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
              return GFCard(
                boxFit: BoxFit.cover,
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
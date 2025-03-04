import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'sidebar.dart';
import 'foodfilter.dart';



void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
  final data = jsonDecode(jsonString); 
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

  @override
  Widget build(BuildContext context) {
    double viewWidth = MediaQuery.sizeOf(context).width;

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
              return GFCard(
                boxFit: BoxFit.cover,
                title: GFListTile(
                  title: Text(jsonData[strIndex]['Name']),
                ),
                content: Text("Food Description"),
                buttonBar: GFButtonBar(
                  children: [
                    GFButton(
                      onPressed: () {},
                      text: 'See more',
                    ),
                  ],
                ),
              );
          },
        ),
      ),
    );
  }
}

int findCardsPerRow(double viewWidth, double minCardWidth) {
  return viewWidth ~/ minCardWidth;
}
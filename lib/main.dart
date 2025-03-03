import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'sidebar.dart';
import 'dbExtract.dart';

void main() async {
  await openDBConnection();
  await getFoodMenu();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double viewWidth = MediaQuery.sizeOf(context).width;
    // double viewHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffbf65),
        title: const Text('Menu Page'),
        
      ),
      drawer: Sidebar(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  findCardsPerRow(viewWidth, 300), // Number of columns in a row
              crossAxisSpacing: 10, // Space between columns
              mainAxisSpacing: 10, // Space between rows
              childAspectRatio: 1.5, // Adjust width/height ratio
            ),
            itemCount: 5, // Added item count
            itemBuilder: (BuildContext context, int index) {
              return GFCard(
                boxFit: BoxFit.cover,
                title: GFListTile(
                  title: Text('Food Name $index'),
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
          )),
    );
  }
}

int findCardsPerRow(double viewWidth, double minCardWidth) {
  return viewWidth ~/ minCardWidth;
}

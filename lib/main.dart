import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'userpage.dart';

void main() {
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
    double viewHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffbf65),
        title: const Text('Menu Page'),
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffffbf65),
              ),
              child: Text("Menu",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Builder(
              // Context
              builder: (context) => GFButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                text: "Go to Menu",
                fullWidthButton: true,
              ),
            ),
            Builder(
              builder: (context) => GFButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserPage()));
                },
                text: "Go to User Page",
                fullWidthButton: true,
              ),
            ),
          ],
        ),
      ),
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

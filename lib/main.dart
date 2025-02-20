import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
// use "flutter pub add getwidget" to run 

import 'homepage.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffbf65),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffffbf65),
              ),
              child: Text("Menu", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Builder( // Context
              builder: (context) => GFButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MenuPage()),
                  );
                },
                text: "Go to Menu",
                fullWidthButton: true,
              ),
            ),
          ],
        ),
      ),
      body: Center(child: Text("Home Page")),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'main.dart';
import 'userpage.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserPage()),
                );
              },
              text: "Go to User Page",
              fullWidthButton: true,
            ),
          ),
        ],
      ),
    );
  }
}
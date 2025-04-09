import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'ui.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFECED),
      body: Stack(
        children: <Widget> [
          ThemedBox(pointA: Offset(55,30), pointB: Offset(800,325)), // Profile Box
          ThemedBox(pointA: Offset(55,350), pointB: Offset(800,760)), // User Info Box
        ]
      )
    );
  }
}
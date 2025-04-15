import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import '../UI/widgets.dart';
import '../UI/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: <Widget> [
          ThemedBox(pointA: Offset(55,30), pointB: Offset(800,325)), // Profile Box
          ThemedBox(pointA: Offset(55,350), pointB: Offset(800,760)), // User Info Box
        ]
      )
    );
  }
}
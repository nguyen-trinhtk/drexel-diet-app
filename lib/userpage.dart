import 'package:flutter/material.dart';

class AppColors {
  static const darkblue = Color(0xff22242f);
  static const lightblue = Color(0xff40798c);
  static const yellow = Color(0xffffbf65);
  static const silk = Color(0xfff6f1d1);
}

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.yellow,
            borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Text(
              'Your mom',
              style: TextStyle(color: AppColors.darkblue),
              ),
            ),
        ),
      ),
    );
  }
}

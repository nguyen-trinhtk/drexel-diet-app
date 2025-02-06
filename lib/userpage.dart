import 'package:flutter/material.dart';

class AppColors {
  static const darkblue = Color(0xff22242f);
  static const lightblue = Color(0xff40798c);
  static const yellow = Color(0xffffbf65);
  static const silk = Color(0xfff6f1d1);
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
      ),
      body: Center(
        child: const Text('This is the User Page'),
      ),
    );
  }
}

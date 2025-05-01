// Blank page that suggest user login
// Page for user's meal history
import 'package:code/UI/custom_elements.dart';
import 'package:flutter/material.dart';
import '../UI/colors.dart';
import '../SSO.dart';

class NoAccountPage extends StatelessWidget {
  const NoAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child:
        Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        CustomText(
          content: "Login to plan meals, track data, and more!",
          header: true,
        ),
        CustomButton(onPressed: () {
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SSOPage())
          );
        },
          text: "Login Now"),
    ]
    ))
    );
  }
}
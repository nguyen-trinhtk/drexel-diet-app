import 'package:code/themes/constants.dart';
import 'package:code/UI/custom_elements.dart';
import 'package:flutter/material.dart';
import 'package:code/SSO-related/SSO.dart';

class NoAccountPage extends StatelessWidget {
  const NoAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              CustomText(
                content: 'Uh-oh :(',
                fontSize: 40,
              ),
              SizedBox(height: 16),
              CustomText(
                content: "Log in to plan meals, track data, and more!",
                header: true,
              ),
              SizedBox(height: 16),
              CustomButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SSOPage()));
                  },
                  text: "Login now"),
            ])));
  }
}

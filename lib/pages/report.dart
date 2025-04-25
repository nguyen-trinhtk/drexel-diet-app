// Page for user's meal history
import 'package:flutter/material.dart';
import '../UI/colors.dart';
import '../backend/meals.dart';
import '../UI/custom_elements.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Column(
          children: [
            CustomText(
              content: 'Calories $dailyTotalCalories'
            ),
            SizedBox(height: 10),
            CustomText(
              content: 'Protein $dailyTotalProtein'
            ),
            SizedBox(height: 10),
            CustomText(
              content: 'Carbs $dailyTotalCarbs'
            ),
            SizedBox(height: 10),
            CustomText(
              content: 'Fat $dailyTotalFat'
            ),
          ],
        ));
  }
}

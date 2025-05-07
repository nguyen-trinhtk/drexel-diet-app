
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
  final int totalCalories = 1050;
  final int consumedCalories = 675;

  final int totalProtein = 100;
  final int consumedProtein = 67;

  final int totalCarbs = 145;
  final int consumedCarbs = 70;

  final int totalFat = 32;
  final int consumedFat = 7;

  @override
  Widget build(BuildContext context) {
    final int leftCalories = totalCalories - consumedCalories;
    final double consumedCaloriesProportion = consumedCalories / totalCalories;
    final double leftCaloriesProportion = leftCalories / totalCalories;

    final int leftProtein = totalProtein - consumedProtein;
    final double consumedProteinProportion = consumedProtein / totalProtein;
    final double leftProteinProportion = leftProtein / totalProtein;

    final int leftCarbs = totalCarbs - consumedCarbs;
    final double consumedCarbsProportion = consumedCarbs / totalCarbs;
    final double leftCarbsProportion = leftCarbs / totalCarbs;

    final int leftFat = totalFat - consumedFat;
    final double consumedFatProportion = consumedFat / totalFat;
    final double leftFatProportion = leftFat / totalFat;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            CustomText(
              content: 'Daily Recap',
              header: true,
              fontSize: 30,
            ),
            SizedBox(height: 50),
            _buildNutrientRow(
              label: 'Calories',
              consumed: consumedCalories,
              left: leftCalories,
              consumedProportion: consumedCaloriesProportion,
              leftProportion: leftCaloriesProportion,
              consumedColor: AppColors.accent,
              leftColor: AppColors.white,
              unit: 'kcal',
            ),
            SizedBox(height: 30),
            _buildNutrientRow(
              label: 'Protein',
              consumed: consumedProtein,
              left: leftProtein,
              consumedProportion: consumedProteinProportion,
              leftProportion: leftProteinProportion,
              consumedColor: AppColors.secondaryBackground,
              leftColor: AppColors.white,
              unit: 'g',
            ),
            SizedBox(height: 30),
            _buildNutrientRow(
              label: 'Carbs',
              consumed: consumedCarbs,
              left: leftCarbs,
              consumedProportion: consumedCarbsProportion,
              leftProportion: leftCarbsProportion,
              consumedColor: AppColors.secondaryBackground,
              leftColor: AppColors.white,
              unit: 'g',
            ),
            SizedBox(height: 30),
            _buildNutrientRow(
              label: 'Fat',
              consumed: consumedFat,
              left: leftFat,
              consumedProportion: consumedFatProportion,
              leftProportion: leftFatProportion,
              consumedColor: AppColors.secondaryBackground,
              leftColor: AppColors.white,
              unit: 'g',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow({
    required String label,
    required int consumed,
    required int left,
    required double consumedProportion,
    required double leftProportion,
    required Color consumedColor,
    required Color leftColor,
    required String unit,
  }) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              child: CustomText(
                content: label,
                header: true,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  flex: (consumedProportion * 100).round(),
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: consumedColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                      border: Border.all(color: AppColors.primaryText),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: CustomText(
                        content: '$consumed$unit',
                        header: true,
                        fontSize: 15,
                        color: AppColors.primaryText,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: (leftProportion * 100).round(),
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: leftColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      border: Border.all(color: AppColors.primaryText),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: CustomText(
                        content: '$left$unit',
                        header: true,
                        fontSize: 16,
                        color: AppColors.secondaryText,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

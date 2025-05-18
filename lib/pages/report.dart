import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code/themes/constants.dart';
import 'package:code/user-data/meals.dart';
import 'package:code/user-data/userdata.dart';
import 'package:code/themes/widgets.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mealsProvider = Provider.of<MealsProvider>(context);

    int dailyTotalCalories = mealsProvider.dailyTotalCalories;
    int dailyTotalProtein = mealsProvider.dailyTotalProtein;
    int dailyTotalCarbs = mealsProvider.dailyTotalCarbs;
    int dailyTotalFat = mealsProvider.dailyTotalFat;

    int leftCalories = goalCalories - dailyTotalCalories;
    int leftProtein = goalProtein - dailyTotalProtein;
    int leftCarbs = goalCarbs - dailyTotalCarbs;
    int leftFat = goalFat - dailyTotalFat;

    double consumedCaloriesProportion =
        dailyTotalCalories / goalCalories;
    double consumedProteinProportion = dailyTotalProtein / goalProtein;
    double consumedCarbsProportion = dailyTotalCarbs / goalCarbs;
    double consumedFatProportion = dailyTotalFat / goalFat;

    double leftCaloriesProportion = leftCalories / goalCalories;
    double leftProteinProportion = leftProtein / goalProtein;
    double leftCarbsProportion = leftCarbs / goalCarbs;
    double leftFatProportion = leftFat / goalFat;

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
              consumed: dailyTotalCalories,
              total:goalCalories,
              consumedProportion: consumedCaloriesProportion,
              leftProportion: leftCaloriesProportion,
              consumedColor: AppColors.accent,
              leftColor: AppColors.white,
              unit: 'kcal',
            ),
            _buildNutrientRow(
              label: 'Protein',
              consumed: dailyTotalProtein,
              total:goalProtein,
              consumedProportion: consumedProteinProportion,
              leftProportion: leftProteinProportion,
              consumedColor: AppColors.accent,
              leftColor: AppColors.white,
              unit: 'g',
            ),
            _buildNutrientRow(
              label: 'Carbs',
              consumed: dailyTotalCarbs,
              total:goalCarbs,
              consumedProportion: consumedCarbsProportion,
              leftProportion: leftCarbsProportion,
              consumedColor: AppColors.accent,
              leftColor: AppColors.white,
              unit: 'g',
            ),
            _buildNutrientRow(
              label: 'Fat',
              consumed: dailyTotalFat,
              total:goalFat,
              consumedProportion: consumedFatProportion,
              leftProportion: leftFatProportion,
              consumedColor: AppColors.accent,
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
    required int total,
    required double consumedProportion,
    required double leftProportion,
    required Color consumedColor,
    required Color leftColor,
    required String unit,
  }) {
    return Column(
      children: [
      Container(
      height: 50,
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
                        color: AppColors.white,
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
                        content: '$total$unit',
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
    ), 
    SizedBox(height: 30)]);
  }
}

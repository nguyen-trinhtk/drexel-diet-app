import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/themes/constants.dart';
import 'package:code/themes/widgets.dart';
import 'package:code/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? uid = Provider.of<UserProvider>(context).userId;

    if (uid == null) {
      return const Center(child: Text("Error: User not logged in."));
    }

    final today = DateFormat('MM-dd-yyyy').format(DateTime.now());
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    final historyDoc = FirebaseFirestore.instance.collection('mealHistory').doc(uid);

    return StreamBuilder<DocumentSnapshot>(
      stream: historyDoc.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final historyData = snapshot.data!.data() as Map<String, dynamic>?;

        if (historyData == null || !historyData.containsKey('mealHistory')) {
          return Center(child: Text("No meal history found for today."));
        }

        final List<dynamic> meals = historyData['mealHistory'];
        final todayMeals = meals.where((meal) => meal['date'] == today);

        int dailyTotalCalories = 0;
        int dailyTotalProtein = 0;
        int dailyTotalCarbs = 0;
        int dailyTotalFat = 0;

        for (var meal in todayMeals) {
          dailyTotalCalories += ((meal['totalCalories'] ?? 0) as num).toInt();
          dailyTotalProtein += ((meal['totalProtein'] ?? 0) as num).toInt();
          dailyTotalCarbs += ((meal['totalCarbs'] ?? 0) as num).toInt();
          dailyTotalFat += ((meal['totalFat'] ?? 0) as num).toInt();
        }

        return FutureBuilder<DocumentSnapshot>(
          future: userDoc.get(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) return Center(child: CircularProgressIndicator());

            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;

            if (userData == null) {
              return Center(child: Text("User goals not set."));
            }

            int goalCalories = userData['goalCalories'] ?? 0;
            int goalProtein = userData['goalProtein'] ?? 0;
            int goalCarbs = userData['goalCarbs'] ?? 0;
            int goalFat = userData['goalFat'] ?? 0;

            double safeDivide(int value, int total) => total == 0 ? 0 : value / total;

            return Scaffold(
              backgroundColor: AppColors.primaryBackground,
              body: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    CustomText(
                      content: 'Daily Recap',
                      header: true,
                      fontSize: 30,
                    ),
                    const SizedBox(height: 50),
                    _buildNutrientRow(
                      label: 'Calories',
                      consumed: dailyTotalCalories,
                      total: goalCalories,
                      consumedProportion: safeDivide(dailyTotalCalories, goalCalories),
                      leftProportion: safeDivide(goalCalories - dailyTotalCalories, goalCalories),
                      consumedColor: AppColors.accent,
                      leftColor: AppColors.white,
                      unit: 'kcal',
                    ),
                    _buildNutrientRow(
                      label: 'Protein',
                      consumed: dailyTotalProtein,
                      total: goalProtein,
                      consumedProportion: safeDivide(dailyTotalProtein, goalProtein),
                      leftProportion: safeDivide(goalProtein - dailyTotalProtein, goalProtein),
                      consumedColor: AppColors.accent,
                      leftColor: AppColors.white,
                      unit: 'g',
                    ),
                    _buildNutrientRow(
                      label: 'Carbs',
                      consumed: dailyTotalCarbs,
                      total: goalCarbs,
                      consumedProportion: safeDivide(dailyTotalCarbs, goalCarbs),
                      leftProportion: safeDivide(goalCarbs - dailyTotalCarbs, goalCarbs),
                      consumedColor: AppColors.accent,
                      leftColor: AppColors.white,
                      unit: 'g',
                    ),
                    _buildNutrientRow(
                      label: 'Fat',
                      consumed: dailyTotalFat,
                      total: goalFat,
                      consumedProportion: safeDivide(dailyTotalFat, goalFat),
                      leftProportion: safeDivide(goalFat - dailyTotalFat, goalFat),
                      consumedColor: AppColors.accent,
                      leftColor: AppColors.white,
                      unit: 'g',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
    return Column(children: [
      Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
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
                    flex: (consumedProportion * 100).clamp(0, 100).round(),
                    child: Container(
                      height: double.infinity,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: consumedColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                        border: Border.all(color: AppColors.primaryText),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
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
                    flex: (leftProportion * 100).clamp(0, 100).round(),
                    child: Container(
                      height: double.infinity,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: leftColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        border: Border.all(color: AppColors.primaryText),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
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
      const SizedBox(height: 30)
    ]);
  }
}

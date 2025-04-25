import 'package:flutter/material.dart';
import 'package:code/UI/widgets.dart';

Map<String, dynamic> mealHistory = {};
List<Widget> historyCards = [];

void buildHistoryCards() {
  historyCards.clear();
  // print(mealHistory);
  mealHistory.forEach((key, value) {
    // print(value['dishes'].keys.toList());
    historyCards.add(ThemedHistoryCard(
      meal: value['name'],
      calories: value['totalCalories'],
      foodList: value['dishes'].keys.toList(),
      protein: value['totalProtein'],
      carbs: value['totalCarbs'],
      fat: value['totalFat'],
    ));
  });
}

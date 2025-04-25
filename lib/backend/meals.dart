import 'package:flutter/material.dart';
import 'package:code/UI/widgets.dart';

Map<String, dynamic> mealHistory = {};
List<Widget> historyCards = [];

void buildHistoryCards() {
  historyCards.clear();
  mealHistory.entries.toList().reversed.forEach((entry) {
    final value = entry.value;
    historyCards.add(ThemedHistoryCard(
      date: value['date'],
      time: value['time'],
      meal: value['name'],
      calories: value['totalCalories'],
      foodList: value['dishes'].keys.toList(),
      protein: value['totalProtein'],
      carbs: value['totalCarbs'],
      fat: value['totalFat'],
    ));
  });
}

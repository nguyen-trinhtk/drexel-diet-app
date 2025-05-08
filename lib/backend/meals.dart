import 'package:flutter/material.dart';
import 'package:code/UI/widgets.dart';

Map<String, dynamic> mealHistory = {};
List<Widget> historyCards = [];

int dailyTotalCalories = 0;
int dailyTotalProtein = 0;
int dailyTotalCarbs = 0;
int dailyTotalFat = 0;

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

class MealsProvider with ChangeNotifier {
  int _dailyTotalCalories = 0;
  int _dailyTotalProtein = 0;
  int _dailyTotalCarbs = 0;
  int _dailyTotalFat = 0;

  int get dailyTotalCalories => _dailyTotalCalories;
  int get dailyTotalProtein => _dailyTotalProtein;
  int get dailyTotalCarbs => _dailyTotalCarbs;
  int get dailyTotalFat => _dailyTotalFat;

  void updateDailyTotalCalories(int newCalories) {
    _dailyTotalCalories = newCalories;
    notifyListeners();
  }

  void updateDailyTotalProtein(int newProtein) {
    _dailyTotalProtein = newProtein;
    notifyListeners();
  }

  void updateDailyTotalCarbs(int newCarbs) {
    _dailyTotalCarbs = newCarbs;
    notifyListeners();
  }

  void updateDailyTotalFat(int newFat) {
    _dailyTotalFat = newFat;
    notifyListeners();
  }
}

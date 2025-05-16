import 'package:flutter/material.dart';
import 'package:code/themes/widgets.dart';

class MealsProvider with ChangeNotifier {
  // Meal history
  Map<String, dynamic> _mealHistory = {};
  List<Widget> _historyCards = [];

  // Daily totals
  int _dailyTotalCalories = 0;
  int _dailyTotalProtein = 0;
  int _dailyTotalCarbs = 0;
  int _dailyTotalFat = 0;

  // Menu and calorie range
  List<dynamic> _menu = [];
  double _minCalories = 0;
  double _maxCalories = 0;

  // Getters
  Map<String, dynamic> get mealHistory => _mealHistory;
  List<Widget> get historyCards => _historyCards;
  int get dailyTotalCalories => _dailyTotalCalories;
  int get dailyTotalProtein => _dailyTotalProtein;
  int get dailyTotalCarbs => _dailyTotalCarbs;
  int get dailyTotalFat => _dailyTotalFat;
  List<dynamic> get menu => _menu;
  double get minCalories => _minCalories;
  double get maxCalories => _maxCalories;

  // Meal history logic
  void setMealHistory(Map<String, dynamic> newHistory) {
    _mealHistory = newHistory;
    buildHistoryCards();
    notifyListeners();
  }

  void buildHistoryCards() {
    _historyCards.clear();
    _mealHistory.entries.toList().reversed.forEach((entry) {
      final value = entry.value;
      _historyCards.add(ThemedHistoryCard(
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

  // Daily total updaters
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

  // Menu and calorie range setters
  void setMenu(List<dynamic> newMenu) {
    _menu = newMenu;
    notifyListeners();
  }

  void setCalorieRange(double min, double max) {
    _minCalories = min;
    _maxCalories = max;
    notifyListeners();
  }
}

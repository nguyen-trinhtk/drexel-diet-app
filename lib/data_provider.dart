import 'package:flutter/material.dart';
import 'package:code/themes/widgets.dart';

class GlobalDataProvider with ChangeNotifier {
  Map<String, dynamic> _menuData = {};
  final List<Map<String, dynamic>> _mealHistory = [];
  final SearchController searchController = SearchController();
  List<Widget> _historyCards = [];
  double _minCalories = 0;
  double _maxCalories = 0;

  Map<String, dynamic> get menuData => _menuData;
  List<Map<String, dynamic>> get mealHistory => _mealHistory;
  List<Widget> get historyCards => _historyCards;
  double get minCalories => _minCalories;
  double get maxCalories => _maxCalories;

  void setMenuData(Map<String, dynamic> newData) {
    _menuData = newData;
    _minCalories = _calculateMinCalories(newData);
    _maxCalories = _calculateMaxCalories(newData);
    notifyListeners();
  }

  void addMealEntry(Map<String, dynamic> entry) {
    _mealHistory.add(entry);
    buildHistoryCards();
    notifyListeners();
  }

  void buildHistoryCards() {
    _historyCards.clear();
    _mealHistory.toList().reversed.forEach((entry) {
      final value = entry;
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
    notifyListeners();
  }

  void clearHistory() {
    _mealHistory.clear();
    _historyCards.clear();
    notifyListeners();
  }

  double _calculateMinCalories(Map<String, dynamic> menu) {
    if (menu.isEmpty) return 0;
    return menu.values
        .map((item) => int.tryParse(item['Calories'] ?? '0') ?? 0)
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
  }

  double _calculateMaxCalories(Map<String, dynamic> menu) {
    if (menu.isEmpty) return 0;
    return menu.values
        .map((item) => int.tryParse(item['Calories'] ?? '0') ?? 0)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
  }
}

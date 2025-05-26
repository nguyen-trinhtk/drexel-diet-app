import 'package:flutter/material.dart';

class FoodDataProvider with ChangeNotifier {
  Map<String, dynamic> _menuData = {};
  double _minCalories = 0;
  double _maxCalories = 0;

  Map<String, dynamic> get menuData => _menuData;
  double get minCalories => _minCalories;
  double get maxCalories => _maxCalories;

  void setMenuData(Map<String, dynamic> newData) {
    _menuData = newData;
    _minCalories = _calculateMinCalories(newData);
    _maxCalories = _calculateMaxCalories(newData);
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

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? get userId => _userId;

  void setUser(String? id) {
    _userId = id;
    notifyListeners();
  }
}

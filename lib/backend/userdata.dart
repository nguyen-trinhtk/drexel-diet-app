import 'package:code/backend/goal_calculator.dart';

Map<DateTime, double> weightProgress = {
  DateTime(2025, 4, 1): 150.0,
  DateTime(2025, 4, 15): 145.5,
  DateTime(2026, 5, 5): 130.0,
};

int daysToGoal = 60;
int age = 20;
double height = 72;
double currentWeight = 130;
double goalWeight = 120;
String gender = 'male';
int goalCalories = calculateCaloricGoal(
    age, height, currentWeight, goalWeight, 3, gender, daysToGoal, 'Imperial');

int goalProtein = proteinGoal(goalCalories);
int goalCarbs = carbsGoal(goalCalories);
int goalFat = fatGoal(goalCalories);
// import 'dart:developer';
import 'dart:io';

// Formula used:  Mifflin and St Jeor Equation (1990)
// Male metric BMR = (10 × weight in kg) + (6.25 × height in cm) – (5 × age in years) + 5
// Female metric BMR = (10 × weight in kg) + (6.25 × height in cm) – (5 × age in years) – 161

int calculateCaloricGoal(
    int age,
    double height, //cm or inches
    double currentWeight, //kg or lbs
    double goalWeight, //kg or lbs
    int activityLevel, //1: sedentary 2: light 3: moderate 4: active 5: very active
    String gender, //birth assigned gender, either 'male' or 'female'
    int daysToGoal,
    String units) //metric or imperial
{
  //unit conversion
  if (units == 'Imperial') {
    //convert into metric
    height *= 2.54;
    currentWeight *= 0.453592;
    goalWeight *= 0.453592;
  } else if (units != 'Metric') {
    // if neither metric nor imperial, throw exception
    throw Exception('Invalid unit type');
  }
  //gender-based BMR
  double bmr = 0;
  if (gender == '♀️') {
    bmr = (10 * currentWeight) + (6.25 * height) - (5 * age) - 161;
  } else if (gender == '♂️') {
    bmr = (10 * currentWeight) + (6.25 * height) - (5 * age) + 5;
  }
  //calorie goal
  if (activityLevel == 1) {
    bmr *= 1.2;
  } else if (activityLevel == 2) {
    bmr *= 1.375;
  } else if (activityLevel == 3) {
    bmr *= 1.55;
  } else if (activityLevel == 4) {
    bmr *= 1.725;
  } else if (activityLevel == 5) {
    bmr *= 1.9;
  }
  double goalCalories =
      bmr - ((currentWeight - goalWeight) * 7700 / daysToGoal);
  return goalCalories.toInt();
}

void main() {
  //example data
  print('Enter your age: ');
  int? age = int.parse(stdin.readLineSync()!);
  print('Enter your height: ');
  double? height = double.parse(stdin.readLineSync()!);
  print('Enter your current weight: ');
  double? currentWeight = double.parse(stdin.readLineSync()!);
  print('Enter your goal weight: ');
  double? goalWeight = double.parse(stdin.readLineSync()!);
  print('Enter your activity level (1: sedentary 2: light 3: moderate 4: active 5: very active): ');
  int? activityLevel = int.parse(stdin.readLineSync()!);
  print('Enter your biological gender: ');
  String gender = stdin.readLineSync()!;
  print('How many days later you want to achieve your goal: ');
  int daysToGoal = int.parse(stdin.readLineSync()!);
  print('Enter your unit used for weight and height: ');
  String units = stdin.readLineSync()!;
  //calculate caloric goal
  int goalCalories = calculateCaloricGoal(
    age,
    height,
    currentWeight,
    goalWeight,
    activityLevel,
    gender,
    daysToGoal,
    units,
  );
  print('Goal Calories: $goalCalories');
}

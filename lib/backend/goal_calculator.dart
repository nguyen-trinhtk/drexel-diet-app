// import 'dart:developer';

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

int proteinGoal(int calories) {
  return (calories * 0.3 / 4).toInt();
}

int carbsGoal(int calories) {
  return (calories * 0.45 / 4).toInt();
}

int fatGoal(int calories) {
  return (calories * 0.25 / 9).toInt();
}

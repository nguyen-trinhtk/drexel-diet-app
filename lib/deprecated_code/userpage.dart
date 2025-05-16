import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../user-data/goal_calculator.dart';
import 'sidebar.dart';

double currentVolume = 3;

class AppColors {
  static const darkblue = Color(0xff22242f);
  static const lightblue = Color(0xff40798c);
  static const yellow = Color(0xffffbf65);
  static const silk = Color(0xfff6f1d1);
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int goalCalories = 0;
  int selectedGenderIndex = 0;
  final List<String> genders = ["♂️", "♀️"];
  DateTime? selectedDate;
  String selectedUnit = "Metric";

  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController goalWeightController = TextEditingController();

  bool isEatWellSelected = false;
  bool isVeganSelected = false;
  bool isVegetarianSelected = false;
  bool isLowCarbonCertifiedSelected = false;
  bool isGlutenFreeSelected = false;
  bool isWholeGrainsSelected = false;
  bool isPlantForwardSelected = false;

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    goalWeightController.dispose();
    super.dispose();
  }

  int daysUntil(String inputDate) {
    try {
      DateTime targetDate = DateFormat('MM-dd-yyyy').parse(inputDate);
      DateTime today = DateTime.now();

      Duration difference = targetDate.difference(today);
      return difference.inDays;
    } catch (e) {
      return -1; // Indicating an error
    }
  }

  void _recordUserInput() {
    final String age = ageController.text;
    final String height = heightController.text;
    final String weight = weightController.text;
    final String goalWeight = goalWeightController.text;
    final String gender = genders[selectedGenderIndex];
    final String unit = selectedUnit;
    final int activityLevel =
        currentVolume.toInt(); // Ensure activity level is an integer
    final String date = selectedDate != null
        ? DateFormat('MM-dd-yyyy').format(selectedDate!)
        : "Date not picked.";
    int daysToGoal = daysUntil(date);

    // Call setState to rebuild the UI with updated goalCalories
    setState(() {
      goalCalories = calculateCaloricGoal(
        int.parse(age),
        double.parse(height),
        double.parse(weight),
        double.parse(goalWeight),
        activityLevel,
        gender,
        daysToGoal,
        unit,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffbf65),
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      drawer: Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // First row - Welcome Banner
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightblue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 80.0, top: 20.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Welcome, User',
                            style: TextStyle(
                              color: AppColors.silk,
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Second row - Calories & Preferences
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.darkblue),
                      ),
                      child: Center(
                        child: Text(
                          'Goal Calories: $goalCalories',
                          style: TextStyle(
                            color: AppColors.darkblue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Third row - Multiple input fields
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  // TextFields for Age, Height, Weight, Goal Weight
                  _buildTextField('Age', ageController, TextInputType.number,
                      FilteringTextInputFormatter.digitsOnly),
                  _buildTextField(
                      'Height',
                      heightController,
                      TextInputType.numberWithOptions(decimal: true),
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))),
                  _buildTextField(
                      'Current Weight',
                      weightController,
                      TextInputType.numberWithOptions(decimal: true),
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))),
                  _buildTextField(
                      'Goal Weight',
                      goalWeightController,
                      TextInputType.numberWithOptions(decimal: true),
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))),
                  // Activity Level with Slider
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Activity Level (1: sedentary, 5: active)",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Slider(
                            value: currentVolume,
                            max: 5,
                            divisions: 5,
                            label: currentVolume.toString(),
                            activeColor: AppColors.darkblue,
                            inactiveColor: AppColors.silk,
                            onChanged: (double value) {
                              setState(() {
                                currentVolume = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Gender Selection using Segmented Buttons
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Gender",
                            style: TextStyle(
                              color: AppColors.darkblue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ToggleButtons(
                            isSelected: List.generate(genders.length,
                                (index) => index == selectedGenderIndex),
                            onPressed: (int index) {
                              setState(() {
                                selectedGenderIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Colors.white,
                            color: AppColors.darkblue,
                            fillColor: AppColors.darkblue,
                            children: genders
                                .map((gender) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(gender,
                                          style: const TextStyle(fontSize: 16)),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Days to Goal
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              var pickedDate = await showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2019),
                                lastDate: DateTime(2050),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                            label: const Text('Days until goal'),
                          ),
                          Text(
                            selectedDate == null
                                ? "Date not picked."
                                : DateFormat('MM-dd-yyyy')
                                    .format(selectedDate!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Unit Dropdown
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Unit',
                              style: TextStyle(
                                color: AppColors.darkblue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 10),
                            DropdownButton<String>(
                              value: selectedUnit,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedUnit = newValue!;
                                });
                              },
                              items: [
                                "Metric",
                                "Imperial"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style:
                                          TextStyle(color: AppColors.darkblue)),
                                );
                              }).toList(),
                              dropdownColor: AppColors.silk,
                              style: TextStyle(
                                  color: AppColors.darkblue, fontSize: 16),
                              underline: Container(
                                  height: 2, color: AppColors.darkblue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Button to record user input
            ElevatedButton(
              onPressed: _recordUserInput,
              child: const Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create text fields
  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType, TextInputFormatter inputFormatter) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: [inputFormatter],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label,
            ),
          ),
        ),
      ),
    );
  }
}

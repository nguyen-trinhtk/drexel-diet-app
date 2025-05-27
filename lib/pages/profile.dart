import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:code/themes/constants.dart';
import 'package:code/themes/widgets.dart';
import 'package:provider/provider.dart';
import 'package:code/backend/goal_calculator.dart';
import 'package:code/data_provider.dart';

// import 'package:code/user-data/meals.dart';

enum Genders { male, female}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ValueNotifier<String> age = ValueNotifier<String>("18");
  final ValueNotifier<String> height = ValueNotifier<String>("72");
  final ValueNotifier<String> currentWeight = ValueNotifier<String>("100");
  final ValueNotifier<int> activityLevel = ValueNotifier<int>(1);
  final ValueNotifier<String> gender = ValueNotifier<String>("female");
  final ValueNotifier<String> goalWeight = ValueNotifier<String>("90");
  final ValueNotifier<int> daysUntilGoal = ValueNotifier<int>(0);
  final TextEditingController ageController = TextEditingController(text: "18");
  final TextEditingController heightController = TextEditingController(text: "72");
  final TextEditingController weightController = TextEditingController(text: "100");
  final TextEditingController goalWeightController = TextEditingController(text: "90");

  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();

    _loadUserData();

    ageController.addListener(() {
      age.value = ageController.text;
    });
    heightController.addListener(() {
      height.value = heightController.text;
    });
    weightController.addListener(() {
      currentWeight.value = weightController.text;
    });
    goalWeightController.addListener(() {
      goalWeight.value = goalWeightController.text;
    });
    age.addListener(() {
      updateFirestore();
    });
    height.addListener(() {
      updateFirestore();
    });
    currentWeight.addListener(() {
      updateFirestore();
    });
    activityLevel.addListener(() {
      updateFirestore();
    });
    gender.addListener(() {
      updateFirestore();
    });
    goalWeight.addListener(() {
      updateFirestore();
    });
    daysUntilGoal.addListener(() {
      updateFirestore();
    });
  }

  Future<void> _loadUserData() async {
    String? uid = Provider.of<UserProvider>(context, listen: false).userId;
    if (uid == null) return;
    var doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists && !_dataLoaded) {
      final data = doc.data()!;
      setState(() {
        ageController.text = (data['age'] ?? 18).toString();
        heightController.text = (data['height'] ?? 72).toString();
        weightController.text = (data['currentWeight'] ?? 100).toString();
        goalWeightController.text = (data['goalWeight'] ?? 90).toString();
        activityLevel.value = data['activityLevel'] ?? 1;
        gender.value = data['gender'] ?? "female";
        daysUntilGoal.value = data['daysToGoal'] ?? 0;
        _dataLoaded = true;
      });
    }
  }

  void _updateDaysUntilGoal(DateTime selectedDate) {
    final today = DateTime.now();
    final difference = selectedDate.difference(today).inDays;
    daysUntilGoal.value = difference > 0 ? difference : 0;
  }

  Future<void> _selectGoalDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 730)),
    );

    if (pickedDate != null) {
      _updateDaysUntilGoal(pickedDate);
    }
  }

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    goalWeightController.dispose();
    age.dispose();
    height.dispose();
    currentWeight.dispose();
    activityLevel.dispose();
    gender.dispose();
    goalWeight.dispose();
    daysUntilGoal.dispose();
    super.dispose();
  }

  void updateFirestore() {
    int goalCalories = calculateCaloricGoal(
      int.parse(age.value),
      double.parse(height.value),
      double.parse(currentWeight.value),
      double.parse(goalWeight.value),
      activityLevel.value,
      gender.value,
      daysUntilGoal.value,
      'Imperial',
    );
    int goalProtein = proteinGoal(goalCalories);
    int goalCarbs = carbsGoal(goalCalories);
    int goalFat = fatGoal(goalCalories);

    String? uid = Provider.of<UserProvider>(context, listen: false).userId;
    if (uid == null) {
      print("Error: User ID is null.");
      return;
    }

    var db = FirebaseFirestore.instance;
    var data = <String, dynamic>{
      'activityLevel': activityLevel.value,
      'age': int.parse(age.value),
      'currentWeight': int.parse(currentWeight.value),
      'daysToGoal': daysUntilGoal.value,
      'gender': gender.value,
      'goalCalories': goalCalories,
      'goalCarbs': goalCarbs,
      'goalFat': goalFat,
      'goalProtein': goalProtein,
      'goalWeight': int.parse(goalWeight.value),
      'height': int.parse(height.value),
    };

    db.collection("users").doc(uid).update(data).onError((e, _) {
      print("Error writing document: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding: EdgeInsets.only(top: 48, bottom: 48, right: 64, left: 64),
          child: Row(
              spacing: 24,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 60,
                    child: Column(
                      spacing: 24,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Expanded(
                              flex: 10,
                              child: ThemedCard(
                                padding: EdgeInsets.only(
                                    left: 32, right: 0, top: 32, bottom: 32),
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(32),
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "../assets/images/han.jpg"),
                                            radius: 100,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.all(32),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomText(
                                                  content: "Name",
                                                  softWrap: true,
                                                  fontSize: 60,
                                                  header: true,
                                                ),
                                                CustomText(
                                                    content:
                                                        "1-month goal plan",
                                                    fontSize: 24)
                                              ]))
                                    ]),
                              ),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.50,
                            child: Expanded(
                                flex: 15,
                                child: ThemedCard(
                                    padding: EdgeInsets.all(32),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 54,
                                          right: 54,
                                        ),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                      content:
                                                          "   User Information ",
                                                      softWrap: true,
                                                      fontSize: 24,
                                                      header: true,
                                                    ),
                                                    Icon(Icons.edit,
                                                        size: 42,
                                                        color:
                                                            Color(0xFF232597)),
                                                    CustomText(
                                                        content: "  ",
                                                        fontSize: 26,
                                                        header: true)
                                                  ]),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                      content: "Age",
                                                      fontSize: 24),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .055,
                                                    child: TextField(
                                                      controller: ageController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        color: AppColors
                                                            .primaryText,
                                                        fontFamily:
                                                            AppFonts.textFont,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "18",
                                                        suffix: CustomText(
                                                          content: "yrs",
                                                          color: AppColors
                                                              .primaryText,
                                                          fontSize: 24,
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color: AppColors
                                                              .secondaryText,
                                                          fontSize: 24,
                                                          fontFamily:
                                                              AppFonts.textFont,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                      content: "Height",
                                                      fontSize: 24),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .055,
                                                    child: TextField(
                                                      controller:
                                                          heightController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        color: AppColors
                                                            .primaryText,
                                                        fontFamily:
                                                            AppFonts.textFont,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "72",
                                                        suffix: CustomText(
                                                          content: "in",
                                                          color: AppColors
                                                              .primaryText,
                                                          fontSize: 24,
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color: AppColors
                                                              .secondaryText,
                                                          fontSize: 24,
                                                          fontFamily:
                                                              AppFonts.textFont,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                      content: "Current Weight",
                                                      fontSize: 24),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .055,
                                                    child: TextField(
                                                      controller:
                                                          weightController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        color: AppColors
                                                            .primaryText,
                                                        fontFamily:
                                                            AppFonts.textFont,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "100",
                                                        suffix: CustomText(
                                                          content: "lbs",
                                                          color: AppColors
                                                              .primaryText,
                                                          fontSize: 24,
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color: AppColors
                                                              .secondaryText,
                                                          fontSize: 24,
                                                          fontFamily:
                                                              AppFonts.textFont,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    content: "Activity Level",
                                                    fontSize: 24,
                                                  ),
                                                  ValueListenableBuilder<int>(
                                                    valueListenable:
                                                        activityLevel,
                                                    builder: (context,
                                                        activityLevelValue,
                                                        child) {
                                                      return Slider(
                                                        value:
                                                            activityLevelValue
                                                                .toDouble(),
                                                        min: 1,
                                                        max: 5,
                                                        divisions: 5,
                                                        label:
                                                            activityLevelValue
                                                                .toString(),
                                                        onChanged:
                                                            (double value) {
                                                          activityLevel.value =
                                                              value.toInt();
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    content: "Gender",
                                                    fontSize: 24,
                                                  ),
                                                  ValueListenableBuilder<
                                                      String>(
                                                    valueListenable: gender,
                                                    builder: (context,
                                                        selectedGender, child) {
                                                      return SegmentedButton<
                                                          String>(
                                                        showSelectedIcon: false,
                                                        segments: const <ButtonSegment<
                                                            String>>[
                                                          ButtonSegment<String>(
                                                              value: "female",
                                                              label: Text('F')),
                                                          ButtonSegment<String>(
                                                              value: "male",
                                                              label: Text('M'))
                                                        ],
                                                        selected: <String>{
                                                          selectedGender
                                                        },
                                                        onSelectionChanged:
                                                            (Set<String>
                                                                newSelection) {
                                                          gender.value =
                                                              newSelection
                                                                  .first;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            ])))))
                      ],
                    )),
                Flexible(
                    flex: 40,
                    child: Column(
                        spacing: 24,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 25,
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: AppColors.accent,
                                      offset: Offset(10, 10)),
                                ], borderRadius: BorderRadius.circular(40)),
                                child: ThemedCard(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                            spacing: 2,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                content: "Goal Weight",
                                                softWrap: true,
                                                fontSize: 24,
                                                header: true,
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .1,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .1,
                                                  child: TextField(
                                                      controller: goalWeightController,
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                      cursorColor: AppColors.accent,
                                                      style: TextStyle(
                                                          fontSize: 48,
                                                          color:
                                                              AppColors.accent,
                                                          fontFamily: AppFonts
                                                              .headerFont),
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration: InputDecoration(
                                                          disabledBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color: AppColors.accent)),
                                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
                                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
                                                          hintText: "90",
                                                          hintStyle: TextStyle(color: const Color.fromARGB(148, 230, 109, 141), fontSize: 48, fontFamily: AppFonts.headerFont),
                                                          floatingLabelBehavior: FloatingLabelBehavior.always))),
                                            ])
                                      ]),
                                ),
                              )),
                          Expanded(
                              flex: 25,
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: AppColors.accent,
                                      offset: Offset(10, 10)),
                                ], borderRadius: BorderRadius.circular(40)),
                                child: ThemedCard(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                            spacing: 2,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                content: "Goal Calories",
                                                softWrap: true,
                                                fontSize: 24,
                                                header: true,
                                              ),
                                              StreamBuilder<DocumentSnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(Provider.of<
                                                                UserProvider>(
                                                            context)
                                                        .userId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator(
                                                      color: AppColors.accent,
                                                    );
                                                  }

                                                  if (snapshot.hasError) {
                                                    return CustomText(
                                                      content: "Error",
                                                      header: true,
                                                      color: Colors.red,
                                                      fontSize: 48,
                                                    );
                                                  }

                                                  if (!snapshot.hasData ||
                                                      !snapshot.data!.exists) {
                                                    return CustomText(
                                                      content: "N/A",
                                                      header: true,
                                                      color: AppColors
                                                          .secondaryText,
                                                      fontSize: 48,
                                                    );
                                                  }

                                                  final goalCalories =
                                                      snapshot.data!.get(
                                                              'goalCalories') ??
                                                          0;

                                                  return CustomText(
                                                    content:
                                                        goalCalories.toString(),
                                                    header: true,
                                                    color: AppColors.accent,
                                                    fontSize: 48,
                                                  );
                                                },
                                              ),
                                            ])
                                      ]),
                                ),
                              )),
                          Expanded(
                              flex: 25,
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: AppColors.accent,
                                      offset: Offset(10, 10)),
                                ], borderRadius: BorderRadius.circular(40)),
                                child: ThemedCard(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                            spacing: 2,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                content: "Days Until Goal",
                                                softWrap: true,
                                                fontSize: 24,
                                                header: true,
                                              ),
                                              ValueListenableBuilder<int>(
                                                valueListenable: daysUntilGoal,
                                                builder:
                                                    (context, days, child) {
                                                  return GestureDetector(
                                                    onTap: () =>
                                                        _selectGoalDate(
                                                            context),
                                                    child: Row(
                                                      children: [
                                                        CustomText(
                                                          content:
                                                              days.toString(),
                                                          header: true,
                                                          color:
                                                              AppColors.accent,
                                                          fontSize: 48,
                                                        ),
                                                        Icon(
                                                          Icons.calendar_today,
                                                          color:
                                                              AppColors.accent,
                                                          size: 24,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ])
                                      ]),
                                ),
                              )),
                          Expanded(
                              flex: 25,
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: AppColors.accent,
                                      offset: Offset(10, 10)),
                                ], borderRadius: BorderRadius.circular(40)),
                                child: ThemedCard(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                            spacing: 2,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              CustomText(
                                                content: "Days Achieved",
                                                softWrap: true,
                                                fontSize: 24,
                                                header: true,
                                              ),
                                              CustomText(
                                                  content: "5",
                                                  header: true,
                                                  color: AppColors.accent,
                                                  fontSize: 48)
                                            ])
                                      ]),
                                ),
                              ))
                        ]))
              ]),
        ));
  }
}

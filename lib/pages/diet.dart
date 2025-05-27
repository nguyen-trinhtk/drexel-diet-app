// Page for user's meal Diet
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:code/themes/constants.dart';
import 'package:code/themes/widgets.dart';
import 'package:code/deprecated_code/userdata.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});
  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.04, horizontal: MediaQuery.of(context).size.width*.04,),
        child: Column(
          spacing: MediaQuery.of(context).size.height*0.02,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              content: 'Current Diet Plan',
              header: true,
              fontSize: 30,
            ),
            Expanded(
              child: Row(
                spacing: MediaQuery.of(context).size.width*0.02,
                children: [
                  // Left Column
                  Expanded(
                    flex: 2,
                    child: Column(
                      spacing: MediaQuery.of(context).size.height*.02,
                      children: [
                        // Calories Container
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AppColors.primaryText),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  content: '$goalCalories',
                                  header: true,
                                  color: AppColors.white,
                                  fontSize: 40,
                                ),
                                CustomText(
                                  content: 'CALORIES',
                                  header: true,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AppColors.primaryText),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                      ),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        content: 'Goal Weight',
                                        header: true,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                      ),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        content: '$goalWeight lbs',
                                        header: true,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Achieve By Container
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AppColors.primaryText),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                      ),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        content: 'Achieve by',
                                        header: true,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                      ),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        content: '07-07-2025',
                                        header: true,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right Container
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.primaryText),
                      ),
                      child: Column(
                        spacing: MediaQuery.of(context).size.height*.02,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.01),
                            child:CustomText(
                              content:
                                  'Current weight: ${weightProgress.values.last} lbs',
                              header: true,
                              color: AppColors.accent,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.height*.025),
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    drawHorizontalLine: true,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: AppColors.secondaryText,
                                      strokeWidth: 1,
                                    ),
                                    getDrawingVerticalLine: (value) => FlLine(
                                      color: AppColors.secondaryText,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, _) {
                                          DateTime startDate =
                                              weightProgress.keys.first;
                                          DateTime date = startDate.add(
                                              Duration(days: value.toInt()));
                                          return Text(
                                              '${date.month}/${date.day}');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, _) =>
                                            Text('${value.toInt()}'),
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                        color: AppColors.primaryText, width: 1),
                                  ),
                                  minX: 0,
                                  maxX: weightProgress.keys.last
                                      .difference(weightProgress.keys.first)
                                      .inDays
                                      .toDouble(),
                                  minY: weightProgress.values
                                          .reduce((a, b) => a < b ? a : b) -
                                      1,
                                  maxY: weightProgress.values
                                          .reduce((a, b) => a > b ? a : b) +
                                      1,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots:
                                          weightProgress.entries.map((entry) {
                                        DateTime startDate =
                                            weightProgress.keys.first;
                                        double x = entry.key
                                            .difference(startDate)
                                            .inDays
                                            .toDouble();
                                        double y = entry.value;
                                        return FlSpot(x, y);
                                      }).toList(),
                                      isCurved:
                                          false, // Set to false for straight lines
                                      color: AppColors.accent,
                                      barWidth: 3,
                                      dotData: FlDotData(show: true),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              spacing: MediaQuery.of(context).size.width*0.01,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomButton(
                    text: 'Update current weight',
                    padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
                    header: true,
                    onPressed: () => print('Update current weight pressed'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomButton(
                    text: 'Reset goal',
                    padding:EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
                    header: true,
                    color: AppColors.white,
                    textColor: AppColors.primaryText,
                    borderColor: AppColors.primaryText,
                    hoverColor: AppColors.tertiaryText,
                    onPressed: () => print('Reset goal pressed'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

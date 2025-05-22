import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code/themes/constants.dart';
import 'package:code/data_provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.01),
        child: Consumer<FoodDataProvider>(
          builder: (context, globalData, child) {
            return ListView(
              children: globalData.historyCards,
            );
          },
        ),
      ),
    );
  }
}

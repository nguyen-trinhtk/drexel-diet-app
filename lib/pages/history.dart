// Page for user's meal history
import 'package:code/UI/widgets.dart';
import 'package:flutter/material.dart';
import '../UI/colors.dart';
import '../backend/meals.dart';



class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: historyCards)));
  }
}

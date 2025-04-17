// Page for user's meal history
import 'package:code/UI/widgets.dart';
import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import '../UI/colors.dart';
import '../UI/custom_text.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HistoryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
        child: ListView.builder(
          itemCount: 2, 
          itemBuilder: (BuildContext context, int index){
            return ThemedHistoryCard(
              calories: 324,
              foodList: ["Lava Chicken", "Bún Đậu Mắm Tôm", "Cajun Chicken"],
              protein: 241,
              carbonhydrates: 391,
              fat: 231); 
          }
        )
      )
        );
    
  }

  @override
  void initState() {
    super.initState();
  }
}
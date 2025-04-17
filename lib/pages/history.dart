// Page for user's meal history
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
            return Card(
              color: AppColors.white,
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppColors.primaryText,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[Column(
                  children: <Widget>[
                    CustomText(
                      content: "413",
                      fontSize: 60,
                      bold: true,
                      ),
                    CustomText(
                      content: "CALORIES",
                      fontSize: 30,
                      color: AppColors.accent,
                      header: true,
                      ),
                    ],
                ),
                Column(
                  children: <Widget>[Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    CustomText(
                      content:"FOOD",
                      fontSize: 20,
                      header: true,
                      color: AppColors.accent,
                      ),
                    SizedBox(
                      width: 10,
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText(
                          content: "Lava Chicken",
                          fontSize: 20,),
                        CustomText(
                          content: "Bún Đậu Mắm Tôm",
                          fontSize: 20,),
                        CustomText(
                          content: "Cajun Chicken",
                          fontSize: 20,),
                      ]
                    ),
                  ],)]
                  
                ),
                Column(
                  children: <Widget>[Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                    CustomText(
                      content:"PROTEIN",
                      fontSize: 20,
                      header: true,
                      color: AppColors.accent,
                      ), 
                    CustomText(
                      content:"CARB",
                      fontSize: 20,
                      header: true,
                      color: AppColors.accent,
                      ),
                    CustomText(
                      content:"FAT",
                      fontSize: 20,
                      header: true,
                      color: AppColors.accent,
                      ),
                    ]),
                    SizedBox(
                      width: 10,
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText(
                          content: "892",
                          fontSize: 20,),
                        CustomText(
                          content: "329",
                          fontSize: 20,),
                        CustomText(
                          content: "293",
                          fontSize: 20,),
                      ]
                    ),
                  ],)]
                  
                ),
                ]
              ),
              ),
            );
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
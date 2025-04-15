// Page for diet plans
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../theme/colors.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DietPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 2, 
          itemBuilder: (BuildContext context, int index){
            return Card(
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
                    Text("Calorie"),
                    Text("100")
                    ],
                ),
                Column(
                  children: <Widget>[Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Say gex"),
                    Column(
                      children: <Widget>[
                        Text("Food 1"),
                        Text("Food 2")
                      ]
                    ),
                  ],)]
                  
                ),
                Column(
                  children: <Widget>[Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Say gex"),
                    Column(
                      children: <Widget>[
                        Text("Food 1"),
                        Text("Food 2")
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
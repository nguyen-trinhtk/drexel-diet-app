import 'package:code/homepage.dart';
import 'package:code/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'foodfilter.dart';
import "ui.dart";


void main() async => runApp(
  ChangeNotifierProvider(
    create: (context) => FoodFilterDrawerState(),
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget>[
        SizedBox(width: double.infinity, height: double.infinity, child:CustomPaint(painter: ThemedSidebar(), size:MediaQuery.of(context).size,)),

        DefaultTabController(
          length: 4, // Number of tabs
          initialIndex: 3,
          child: Scaffold(
            backgroundColor: Color.fromARGB(0, 255, 236, 237),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Vertical TabBar on the left side
                RotatedBox(
                  quarterTurns: 3,
                  child:TabBar(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    dividerColor: Color.fromARGB(0, 255, 255, 255),
                    physics: const NeverScrollableScrollPhysics(),
                    isScrollable: true,
                    onTap: (index) {if (index == 0){DefaultTabController.of(context).animateTo(0);}},
                    tabs: [
                      SizedBox(width: 430, height:210),
                      Padding(padding:EdgeInsetsDirectional.all(0), child:RotatedBox(quarterTurns: 1, child:Tab(child:Text('Diet Plans', style:GoogleFonts.kronaOne(textStyle:TextStyle(fontSize: 25,)))))),
                      Padding(padding:EdgeInsetsDirectional.all(0), child:RotatedBox(quarterTurns: 1, child:Tab(child:Text('Profile', style:GoogleFonts.kronaOne(textStyle:TextStyle(fontSize: 25,)))))),
                      Padding(padding: EdgeInsetsDirectional.all(0), child:RotatedBox(quarterTurns: 1, child:Tab(child:Text('Home', style:GoogleFonts.kronaOne(textStyle:TextStyle(fontSize: 25,)))))),
                    ],
                    labelColor: const Color(0xFFE66D8D), // Optional: change the label color
                    unselectedLabelColor: const Color.fromARGB(255, 255, 255, 255), // Optional: change unselected color
                    indicatorColor: Colors.transparent, // Optional: change the indicator color
                  ),
                ),
                // The content area for TabBarView
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Center(child: Text("Blank")),
                      Center(child: Text("Blank")),
                      Profilepage(),
                      Homepage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(left:0, bottom: 50, child:AbsorbPointer(child:SizedBox(width:205,height:460))),
      ]
    );


}}
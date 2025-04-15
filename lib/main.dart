import 'package:code/pages/home.dart';
import 'package:code/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'pages/filter.dart';
import 'theme/ui.dart';
import 'theme/colors.dart';
import 'theme/custom_text.dart';

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
    return Stack(children: <Widget>[
      SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: ThemedSidebar(),
            size: MediaQuery.of(context).size,
          )),
      DefaultTabController(
        length: 5,
        initialIndex: 4,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 236, 237),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: TabBar(
                  overlayColor:
                      WidgetStateProperty.all(AppColors.transparentBlack),
                  dividerColor: AppColors.transparentWhite,
                  physics: const NeverScrollableScrollPhysics(),
                  isScrollable: true,
                  //tabAlignment: TabAlignment.center,
                  onTap: (index) {
                    if (index == 0) {
                      DefaultTabController.of(context).animateTo(0);
                    }
                  },
                  tabs: [
                    SizedBox(width: 225, height: 275),
                    Padding(
                        padding: EdgeInsetsDirectional.all(0),
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Tab(
                                child: CustomText(
                                    content: 'Settings',
                                    header: true,
                                    fontSize: 25)))),
                    Padding(
                        padding: EdgeInsetsDirectional.all(0),
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Tab(
                                child: CustomText(
                                    content: 'Diet Plans',
                                    header: true,
                                    fontSize: 25)))),
                    Padding(
                        padding: EdgeInsetsDirectional.all(0),
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Tab(
                                child: CustomText(
                                    content: 'Profile',
                                    header: true,
                                    fontSize: 25)))),
                    Padding(
                        padding: EdgeInsetsDirectional.all(0),
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Tab(
                                child: CustomText(
                                    content: 'Home',
                                    header: true,
                                    fontSize: 25)))),
                  ],
                  labelColor: AppColors.accent,
                  unselectedLabelColor: AppColors.white,
                  indicatorColor: AppColors.transparentBlack,
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(child: Text("Blank")),
                    Center(child: Text("Blank")),
                    Center(child: Text("Blank")),
                    ProfilePage(),
                    HomePage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      Positioned(
          left: 0,
          bottom: 50,
          child: AbsorbPointer(child: SizedBox(width: 275, height: 255))),
      
      /*Positioned(
        left:10,
        top:30,
        child: Image.asset('../assets/images/logo.png', scale: 3)
      ),*/
    ]);
  }
}

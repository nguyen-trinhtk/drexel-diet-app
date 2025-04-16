import 'package:code/pages/home.dart';
import 'package:code/pages/profile.dart';
import 'package:code/pages/diet.dart';
import 'package:flutter/material.dart';
import 'pages/filter.dart';

// import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'UI/widgets.dart';
import 'UI/colors.dart';
import 'UI/custom_text.dart';

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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Row(
        children: [
          Container(
            width: 200,
            height: double.infinity,
            decoration: const BoxDecoration(),
            child: Stack(
              children: [
                SizedBox(
                  width: 200,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: ThemedSidebar(width: 200),
                  ),
                ),
                Container(
                  width: 100,
                  height: 200,
                  margin: const EdgeInsets.only(left: 100),
                  color: AppColors.primaryBackground
                ),
                Column(
                    children: List.generate(4, (index) {
                      final labels = ['Home', 'Profile', 'History', 'Settings'];
                      final label = labels[index];
                      final isSelected = _tabController.index == index;
                      final isBeforeSelected =
                          index == _tabController.index - 1;
                      final isAfterSelected = index == _tabController.index + 1;
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _tabController.animateTo(index);
                            });
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryBackground
                                  : AppColors.secondaryBackground,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isSelected ? 50 : 0),
                                bottomLeft:
                                    Radius.circular(isSelected ? 50 : 0),
                                topRight:
                                    Radius.circular(isAfterSelected ? 50 : 0),
                                bottomRight:
                                    Radius.circular(isBeforeSelected ? 50 : 0),
                              ),
                            ),
                            child: CustomText(
                              content: label,
                              header: true,
                              fontSize: 20,
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                ),
              ],
            ),
          ),

          // Tab content
          Flexible(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomePage(),
                ProfilePage(),
                DietPage(),
                Center(child: Text("Blank")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

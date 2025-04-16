import 'package:code/pages/home.dart';
import 'package:code/pages/profile.dart';
import 'package:code/pages/history.dart';
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
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);

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
                  height: 250,
                  margin: const EdgeInsets.only(left: 100, top: 150),
                  color: AppColors.primaryBackground
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Column(
                    children: List.generate(5, (index) {
                      final labels = ['Home', 'Profile', 'Diet Plans', 'History', 'Settings'];
                      final icons = [Icons.home_outlined, Icons.person_outlined, Icons.bookmark_outline, Icons.history_outlined, Icons.settings_outlined];
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
                                    Radius.circular(isAfterSelected ? 25 : 0),
                                bottomRight:
                                    Radius.circular(isBeforeSelected ? 25 : 0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  icons[index],
                                  color: isSelected ? AppColors.accent : AppColors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                CustomText(
                                  content: label,
                                  header: true,
                                  fontSize: 16,
                                  color: isSelected ? AppColors.accent : AppColors.white,
                                ),
                              ],
                            ),

                          ),
                        ),
                      );
                      }),
                    ),
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
                Center(child: Text("Blank")),
                HistoryPage(),
                Center(child: Text("Blank")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

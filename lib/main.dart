import 'package:code/pages/home.dart';
import 'package:code/pages/profile.dart';
import 'package:code/pages/dietpage.dart';
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 4);

    _tabController.addListener(() {
      // Ensures the tab is updated when switching
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
    return Stack(
      children: <Widget>[
        // Sidebar with CustomPaint
        SizedBox(
          width: 200,
          height: double.infinity,
          child: CustomPaint(
            painter: ThemedSidebar(width: 200),
            size: MediaQuery.of(context).size,
          ),
        ),
        Positioned(
          left: 100,
          top: 115,
          child: Container(
            width: 160,
            height: 182,
            color: AppColors.primaryBackground,
          ),
        ),
        Scaffold(
          backgroundColor: AppColors.transparentBlack,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sidebar for tabs
              SizedBox(
                width: 200,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    physics: const NeverScrollableScrollPhysics(),
                    isScrollable: true,
                    onTap: (index) {
                      setState(() {
                        _tabController.animateTo(index);
                      });
                    },
                    tabs: List.generate(5, (index) {
                      final labels = ['Settings', 'Diet Plans', 'Profile', 'Home'];
                      if (index == 0) {
                        return const SizedBox(width: 200, height: 275);
                      } else {
                        final label = labels[index - 1];
                        final isSelected = _tabController.index == index;
                        final isBeforeSelected = index == _tabController.index - 1;
                        final isAfterSelected = index == _tabController.index + 1;
                        return RotatedBox(
                          quarterTurns: 1,
                          child: Tab(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                width: 200,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryBackground : AppColors.secondaryBackground,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(isSelected ? 200 : 0),
                                    bottomLeft: Radius.circular(isSelected ? 200 : 0),
                                    topRight: Radius.circular(isBeforeSelected ? 200 : 0),
                                    bottomRight: Radius.circular(isAfterSelected ? 200 : 0),
                                  ),
                                ),
                                child: CustomText(
                                  content: label,
                                  header: true,
                                  fontSize: 20,
                                  color: isSelected ? AppColors.accent : AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                ),
              ),
              Flexible(
                child: TabBarView(
                  controller: _tabController, // Ensure TabController is connected here
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(child: Text("Blank")),
                    Center(child: Text("Blank")),
                    DietPage(),
                    ProfilePage(),
                    HomePage(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          bottom: 50,
          child: AbsorbPointer(
            child: SizedBox(width: 200, height: 255),
          ),
        ),
      ],
    );
  }
}
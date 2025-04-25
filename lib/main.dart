import 'package:code/SSO.dart';
import 'package:code/pages/home.dart';
import 'package:code/pages/profile.dart';
import 'package:code/pages/history.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'pages/filter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'UI/widgets.dart';
import 'UI/colors.dart';
import 'UI/custom_elements.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await dotenv.load(fileName: ".env"); // Load environment variables
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => FoodFilterDrawerState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
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
    _tabController = TabController(length: 7, vsync: this, initialIndex: 1);

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
                  height: 450,
                  margin: const EdgeInsets.only(left: 100, top: 0),
                  color: AppColors.primaryBackground,
                ),
                Column(
                  children: List.generate(7, (index) {
                    final isSelected = _tabController.index == index;
                    final isBeforeSelected = index == _tabController.index - 1;
                    final isAfterSelected = index == _tabController.index + 1;
                    if (index == 0) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBackground,
                          borderRadius: BorderRadius.only(
                            bottomRight: isBeforeSelected
                                ? Radius.circular(25)
                                : Radius.zero,
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            Image.asset(
                              '../assets/logo.png',
                              width: 150,
                              height: 150,
                            ),
                            CustomText(
                              content: 'ANODREXIA',
                              fontSize: 16,
                              header: true,
                              bold: true,
                            ),
                          ],
                        ),
                      );
                    } else if (index == 6) {
                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBackground,
                          borderRadius: BorderRadius.only(
                            topRight: isAfterSelected
                                ? Radius.circular(25)
                                : Radius.zero,
                          ),
                        ),
                      );
                    } else {
                      final labels = [
                        'Home',
                        'Profile',
                        'Diet Plans',
                        'History',
                        'Settings'
                      ];
                      final icons = [
                        Icons.home_outlined,
                        Icons.person_outlined,
                        Icons.bookmark_outline,
                        Icons.history_outlined,
                        Icons.settings_outlined
                      ];
                      final label = labels[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _tabController.animateTo(index);
                            });
                          },
                          child: Container(
                            height: 40,
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
                                  icons[index - 1],
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                CustomText(
                                  content: label,
                                  header: true,
                                  fontSize: 16,
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }),
                ),
                Positioned(
                  bottom: 35,
                  child: Container(
                    height: 50,
                    width: 200,
                    color: AppColors.secondaryBackground,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30),
                    child: TextButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Logged out or some action')),
                      ),
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Row(children: buttonUserLoggedInOut(context)
                    ),
                    )
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Center(child: Text("Blank")),
                const HomePage(),
                const ProfilePage(),
                Center(child: Text("Blank")),
                const HistoryPage(),
                Center(child: Text("Blank")),
                Center(child: Text("Blank")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> buttonUserLoggedInOut(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;
  String logInOutText = "";
  auth
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      logInOutText = "Log In";
    } else {
      logInOutText = "Log Out";
    }
  });

    return [
                    Icon(Icons.logout_outlined, color: AppColors.accent, size: 24),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const SSOPage())
                        );
                      }, 
                    child: CustomText(
                      content: logInOutText,
                      header: true,
                      fontSize: 16,
                      color: AppColors.accent, 
                      bold: true,
                    ),)
                    
                  
    ];
  
}
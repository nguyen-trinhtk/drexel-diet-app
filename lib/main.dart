import 'package:code/SSO.dart';
import 'package:code/pages/diet.dart';
import 'package:code/pages/home.dart';
import 'package:code/pages/profile.dart';
import 'package:code/pages/history.dart';
import 'package:code/pages/report.dart';
import 'package:flutter/material.dart';
import 'pages/filter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'UI/widgets.dart';
import 'UI/colors.dart';
import 'UI/custom_elements.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/no_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'backend/meals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await dotenv.load(fileName: ".env"); // Load environment variables
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FoodFilterDrawerState()),
        ChangeNotifierProvider(create: (context) => MealsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> dataCheck(
      String userId, Map<String, dynamic> newUserData) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      DocumentSnapshot snapshot = await userRef.get();
      if (!snapshot.exists) {
        await userRef.set(newUserData);
        print('User data created successfully for $userId.');
      } else {
        print('User data already exists for $userId.');
      }
    } catch (error) {
      print('Error checking or creating user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;

            if (user != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                dataCheck(user.uid, {
                  'uid': user.uid,
                  'name': user.displayName ?? '',
                  'picture': user.photoURL ?? '',
                  'age': null,
                  'weight': null,
                  'height': null,
                  'sex': null,
                  'activityLevel': null,
                  'email': user.email,
                });
              });
            }
            return HomeScreen(loginState: user);
          }
          return CircularProgressIndicator();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User? loginState;
  const HomeScreen({super.key, this.loginState});

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
                              '../assets/colored-logo.png',
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
                        'Report'
                      ];
                      final icons = [
                        Icons.home_outlined,
                        Icons.person_outlined,
                        Icons.bookmark_outline,
                        Icons.history_outlined,
                        Icons.assignment_outlined
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buttonUserLoggedInOut(context, widget.loginState),
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
              children: navigationBarPages(context, widget.loginState),
            ),
          ),
        ],
      ),
    );
  }
}

// Return a list of pages for navigation bar depending on user login state
List<Widget> navigationBarPages(BuildContext context, User? user) {
  if (user == null) {
    return [
      Center(child: Text("Blank")),
      const HomePage(),
      const NoAccountPage(),
      const NoAccountPage(),
      const NoAccountPage(),
      const NoAccountPage(),
      Center(child: Text("Blank")),
    ];
  } else {
    return [
      Center(child: Text("Blank")),
      const HomePage(),
      const ProfilePage(),
      const DietPage(),
      const HistoryPage(),
      ReportPage(),
      Center(child: Text("Blank")),
    ];
  }
}

// Return Login/Logout Button based on user login state and redirect to SSO page
List<Widget> buttonUserLoggedInOut(BuildContext context, User? user) {
  String logInOutText = "";
  Icon logIcon;

  if (user == null) {
    logInOutText = "Log In";
    logIcon = Icon(Icons.login_outlined, color: AppColors.accent, size: 24);
  } else {
    logInOutText = "Log Out";
    logIcon = Icon(Icons.logout_outlined, color: AppColors.accent, size: 24);
  }

    return [ 
                    // Login/Logout button 
                    ElevatedButton(
                      onPressed: () async {
                        if (user == null) {
                        Navigator.of(context).push(
                          // Redirect to SSO page
                          MaterialPageRoute(builder: (context) =>(const SSOPage()))
                        );
                      }
                      else{
                        // Asking if user wants to log out
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: CustomText(content: 'Are you sure you want to log out?', color: AppColors.accent, header: true, fontSize: 24),
                            backgroundColor: AppColors.white,
                            iconColor: AppColors.accent,
                            actions: [
                              CustomButton(onPressed: () {}, text: 'NO', header: true,),
                              CustomButton(onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pop(); // Dismiss dialog after clicked
                                },
                                text: 'YES', header: true,)
                            ]
                          )
                        );
                      } 
                      },
                    child: Row(
                      children: [  
                      // Login/Logout Icon
                      //logIcon,
                      CustomText(
                      content: logInOutText,
                      header: true,
                      fontSize: 16,
                      color: AppColors.accent, 
                      bold: true,
                    ),
                    ])
                    )
                    
                  
    ];
  
}

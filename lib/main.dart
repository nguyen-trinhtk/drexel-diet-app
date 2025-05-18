import 'package:code/data_provider.dart';
import 'package:code/SSO-related/SSO.dart';
import 'package:code/SSO-related/firebase_options.dart';
import 'package:code/SSO-related/no_account.dart';
import 'package:code/pages/diet.dart';
import 'package:code/pages/home.dart';
import 'package:code/pages/profile.dart';
import 'package:code/pages/history.dart';
import 'package:code/pages/report.dart';
import 'package:code/pages/filter.dart';
import 'package:code/themes/widgets.dart';
import 'package:code/themes/constants.dart';
import 'package:flutter/material.dart';
import 'package:code/user-data/meals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FoodFilterDrawerState()),
        ChangeNotifierProvider(create: (context) => MealsProvider()),
        ChangeNotifierProvider(create: (_) => GlobalDataProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> dataCheck(String userId, Map<String, dynamic> newUserData) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
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
          return const CircularProgressIndicator();
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
          _buildSidebar(context),
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

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 200,
      height: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(200, double.infinity),
            painter: ThemedSidebar(width: 200),
          ),
          Container(
            width: 100,
            height: 450,
            margin: const EdgeInsets.only(left: 100),
            color: AppColors.primaryBackground,
          ),
          Column(
            children: List.generate(7, (index) => _buildSidebarItem(index)),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buttonUserLoggedInOut(context, widget.loginState)),
          )

        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index) {
    final isSelected = _tabController.index == index;
    final isBeforeSelected = index == _tabController.index - 1;
    final isAfterSelected = index == _tabController.index + 1;

    if (index == 0) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.only(
            bottomRight: isBeforeSelected ? Radius.circular(25) : Radius.zero,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Image.asset('../assets/colored-logo.png', width: 150, height: 150),
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
            topRight: isAfterSelected ? Radius.circular(25) : Radius.zero,
          ),
        ),
      );
    } else {
      final labels = ['Home', 'Profile', 'Diet Plans', 'History', 'Report'];
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
          onTap: () => setState(() => _tabController.animateTo(index)),
          child: Container(
            height: 40,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBackground : AppColors.secondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isSelected ? 50 : 0),
                bottomLeft: Radius.circular(isSelected ? 50 : 0),
                topRight: Radius.circular(isAfterSelected ? 25 : 0),
                bottomRight: Radius.circular(isBeforeSelected ? 25 : 0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icons[index - 1],
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
    }
  }
}

List<Widget> navigationBarPages(BuildContext context, User? user) {
  if (user == null) {
    return [
      const Center(child: Text("Blank")),
      const HomePage(),
      const NoAccountPage(),
      const NoAccountPage(),
      const NoAccountPage(),
      const NoAccountPage(),
      const Center(child: Text("Blank")),
    ];
  } else {
    return [
      const Center(child: Text("Blank")),
      const HomePage(),
      const ProfilePage(),
      const DietPage(),
      const HistoryPage(),
      ReportPage(),
      const Center(child: Text("Blank")),
    ];
  }
}

List<Widget> buttonUserLoggedInOut(BuildContext context, User? user) {
  String logInOutText = user == null ? "Log In" : "Log Out";
  Icon logIcon = Icon(
    user == null ? Icons.input_outlined : Icons.output_outlined,
    color: AppColors.accent,
    size: 24,
  );

  return [
    ElevatedButton(
      onPressed: () async {
        if (user == null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SSOPage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: CustomText(
                content: 'Are you sure you want to log out?',
                header: true,
                fontSize: 18,
              ),
              backgroundColor: AppColors.white,
              iconColor: AppColors.accent,
              actions: [
                CustomButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  text: 'NO', bold: true, 
                  color: AppColors.accent,
                  hoverColor: AppColors.primaryText),
                CustomButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                  },
                  text: 'YES',
                  bold: true,
                  color: AppColors.accent, 
                  hoverColor: AppColors.primaryText,
                ),
              ],
            ),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logIcon,
          const SizedBox(width: 8),
          CustomText(
            content: logInOutText,
            header: true,
            fontSize: 16,
            color: AppColors.accent,
            bold: true,
          ),
        ],
      ),
    ),
  ];
}
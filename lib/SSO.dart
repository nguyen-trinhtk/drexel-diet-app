// SSO Login Page
//Ben Pummer
import 'package:code/UI/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
// import 'package:getwidget/getwidget.dart';
import '../../../UI/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UI/fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SSOPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SSOPage extends StatefulWidget {
  const SSOPage({super.key});

  @override
  _SSOPageState createState() => _SSOPageState();
}

class _SSOPageState extends State<SSOPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              content: "Anodrexia",
              fontSize: 50,
              header: true
              ),
            CustomText(
              content: "Your personalized Drexel Dining Assistant",
              fontSize: 30,
              overflow: TextOverflow.visible,
              ),

            const SizedBox(height: 16), // spacing between the buttons
            GFButton(
              onPressed: () async {
                // Define the action when the Microsoft button is pressed
                final providerMS = OAuthProvider("microsoft.com");
                providerMS.setCustomParameters({
                  "tenant": "f18072f9-04d3-477f-b8aa-7e1ddbaac08e"
                });
                await FirebaseAuth.instance.signInWithProvider(providerMS);
              },
              icon: const Icon(FontAwesomeIcons.microsoft),
              text: "Use a Microsoft account to sign in",
              color: AppColors.accent,
              disabledColor: AppColors.accent,
              hoverColor: AppColors.primaryText,
              borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              textStyle: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.textFont,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10), // spacing between the buttons
            GFButton(
              onPressed: () async {
                // Define the action when the Google button is pressed
                final providerG = OAuthProvider("google.com");
                await FirebaseAuth.instance.signInWithProvider(providerG);
              },
              icon: const Icon(FontAwesomeIcons.google),
              text: "Use a Google account to sign in",
              color: AppColors.accent,
              disabledColor: AppColors.accent,
              hoverColor: AppColors.primaryText,
              borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              textStyle: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.textFont,
                fontSize: 16,
              )
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Additional init code if needed
  }
}

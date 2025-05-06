// SSO Login Page
import 'package:code/UI/custom_elements.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
// import 'package:getwidget/getwidget.dart';
import '../../../UI/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universal_html/html.dart' as html; // For refreshing web page

import 'UI/fonts.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SSOPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

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
            Image.asset(
              '../assets/colored-logo.png', 
              width: 200, 
            ),
            CustomText(
              content: "Anodrexia",
              fontSize: 40,
              header: true
              ),
            SizedBox(height: 5),
            CustomText(
              fontSize: 20,
              content: "Your personalized Drexel Dining Assistant",
              ),

            const SizedBox(height: 15), // spacing between the buttons
            GFButton(
              onPressed: () async {
                // Define the action when the Microsoft button is pressed
                final providerMS = OAuthProvider("microsoft.com");
                providerMS.setCustomParameters({
                  "tenant": dotenv.env['SSO_TENANT'] ?? '',
                });
                await FirebaseAuth.instance.signInWithPopup(providerMS);
                html.window.location.reload();
              },
              icon: const Icon(FontAwesomeIcons.microsoft),
              text: "Log in with Microsoft",
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
                await FirebaseAuth.instance.signInWithPopup(providerG);
                html.window.location.reload();
              },
              icon: const Icon(FontAwesomeIcons.google),
              text: "Log in with Google",
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

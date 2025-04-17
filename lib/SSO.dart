// SSO Login Page
//Ben Pummer
import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import '../../../UI/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: DietPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
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
              label: const Text("Use a Microsoft account to sign in"),
            ),
            const SizedBox(height: 16), // spacing between the buttons
            ElevatedButton.icon(
              onPressed: () async {
                // Define the action when the Google button is pressed
                final providerG = OAuthProvider("google.com");
                await FirebaseAuth.instance.signInWithProvider(providerG);
              },
              icon: const Icon(FontAwesomeIcons.google),
              label: const Text("Use a Google account to sign in"),
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

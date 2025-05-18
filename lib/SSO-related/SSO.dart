// SSO Login Page
import 'package:code/themes/constants.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universal_html/html.dart' as html;
import 'package:code/themes/widgets.dart';

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
            const SizedBox(height: 15),
            GFButton(
              onPressed: () async {
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
            const SizedBox(height: 10),
            GFButton(
              onPressed: () async {
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
}

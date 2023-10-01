import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/pages/home.dart';
import 'package:asra_app_new/pages/login.dart';
import 'package:asra_app_new/pages/onboard.dart';
import 'package:asra_app_new/widgets/templates.dart';
import 'package:flutter/material.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _turns = 0;
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(milliseconds: 30),
      (t) async {
        setState(() => _turns += 0.01);
        if (_turns < 1) return;
        final prefs = await SharedPreferences.getInstance();
        final firstTime = !prefs.containsKey('FIRST_TIME');
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => prefs.containsKey('AUTH_TOKEN')
                  ? const HomePage()
                  : (firstTime ? const OnBoardPage() : const LoginPage()),
            ),
          );
        }
        t.cancel();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TopImageEtchedWidget(
      top: null,
      child: Column(
        children: [
          Image.asset(
            'assets/splash_logo.png',
            width: 120,
          ),
          const SizedBox(height: Dimensions.heightSize * 2),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.marginSize * 2),
            child: Text(
              S.of(context).asraUnifiedPlatform,
              style: GoogleFonts.roboto(
                fontSize: Dimensions.largeTextSize,
                color: CustomColor.accentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Dimensions.heightSize * 4),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.marginSize * 4),
            width: MediaQuery.of(context).size.width,
            height: 8.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: const LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                CustomColor.accentColor,
              ),
              //value: 0.8,
            ),
          )
        ],
      ),
    );
  }
}

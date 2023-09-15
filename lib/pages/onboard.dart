import 'package:asra_app_new/widgets/templates.dart';
import 'package:flutter/material.dart';
import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class OnBoardingItem {
  final String title;
  final String subTitle;
  final String image;

  const OnBoardingItem({
    required this.title,
    required this.subTitle,
    required this.image,
  });
}

final pages = [
  const OnBoardingItem(
    title: 'ASRA Driver',
    subTitle: 'Make money with e-hailing 1',
    image: 'assets/imgs/splash.png',
  ),
  const OnBoardingItem(
    title: 'ASRA Driver',
    subTitle: 'Make money with e-hailing 2',
    image: 'assets/imgs/splash.png',
  ),
  const OnBoardingItem(
    title: 'ASRA Driver',
    subTitle: 'Make money with e-hailing 3',
    image: 'assets/imgs/splash.png',
  ),
];

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  bool _loading = true;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('FIRST_TIME', false);
      setState(() => _loading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    final totalPages = pages.length;
    final padding =
        (MediaQuery.of(context).size.width - 25 - 24 * (pages.length - 1) - 4) /
            2;
    return PageView.builder(
      itemCount: totalPages,
      itemBuilder: (context, index) {
        final oi = pages[index];
        return TopImageEtchedWidget(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60.0),
                Text(
                  oi.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: CustomColor.accentColor,
                    fontSize: Dimensions.extraLargeTextSize * 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // ),
                const SizedBox(height: 20.0),
                // Padding(
                //   padding: const EdgeInsets.only(left: 40.0),
                //   child:
                Text(
                  oi.subTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: CustomColor.accentColor,
                    fontSize: Dimensions.extraLargeTextSize,
                  ),
                ),
                // ),
                const SizedBox(height: 60.0),
                index != (totalPages - 1)
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 15.0,
                          child: ListView.builder(
                            itemCount: totalPages,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  width: index == i ? 25 : 20.0,
                                  decoration: BoxDecoration(
                                    color: index == i
                                        ? CustomColor.accentColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: CustomColor.accentColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 0.5),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context).getStarted.toUpperCase(),
                                style: GoogleFonts.roboto(
                                  color: CustomColor.primaryColor,
                                  fontSize: Dimensions.largeTextSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

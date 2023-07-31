import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/pages/register.dart';
import 'package:asra_app_new/widgets/custom_input.dart';
import 'package:asra_app_new/error.dart';
import 'package:asra_app_new/widgets/templates.dart';
import 'package:flutter/material.dart';

import 'package:asra_app_new/utils/dimensions.dart';
import 'package:asra_app_new/utils/custom_style.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String selectedCounty = 'Malaysia';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool checkRememberMe = false;

  @override
  void initState() {
    super.initState();
    emailController.text = 'arif.ghaffar@gmail.com';
    passwordController.text = '1234';
  }

  void _login() async {
    final response = await Api.json.post('/login', {
      'user': emailController.text,
      'pass': passwordController.text,
    });
    try {
      if (!response['success']) throw Error(response['message']);
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString('AUTH_TOKEN', response['token']);
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e is Error ? e.message : e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TopImageTemplateWidget(
      child: Column(
        children: [
          Text(
            'Vehicles Registration', //S.of(context).signInAccount,
            style: GoogleFonts.roboto(
              fontSize: Dimensions.extraLargeTextSize,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryColor,
            ),
          ),
          const SizedBox(height: Dimensions.heightSize * 3),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).email,
                    style: GoogleFonts.roboto(
                      fontSize: Dimensions.defaultTextSize,
                      color: CustomColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.heightSize),
                  CustomTextField(
                      controller: emailController,
                      hintText: S.of(context).email),
                  const SizedBox(height: Dimensions.heightSize * 2),
                  Text(
                    S.of(context).password,
                    style: GoogleFonts.roboto(
                      fontSize: Dimensions.defaultTextSize,
                      color: CustomColor.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: Dimensions.heightSize,
                  ),
                  CustomPasswordField(controller: passwordController),
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimensions.heightSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCheckboxField(
                title: Text(
                  S.of(context).rememberMe,
                  style: CustomStyle.textStyle,
                ),
                checked: checkRememberMe,
                onToggle: (val) => setState(() => checkRememberMe = val),
              ),
              GestureDetector(
                child: Text(
                  S.of(context).forgotPassword,
                  style: TextStyle(
                    fontSize: Dimensions.defaultTextSize,
                    color: CustomColor.blueColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: Dimensions.heightSize * 3),
          GestureDetector(
            onTap: _login,
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radius * 0.5)),
              ),
              child: Center(
                child: Text(
                  S.of(context).signIn.toUpperCase(),
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: Dimensions.largeTextSize,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.heightSize * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.of(context).dontHaveAccount,
                style: CustomStyle.textStyle,
              ),
              GestureDetector(
                child: Text(
                  S.of(context).signUp,
                  style: TextStyle(
                      fontSize: Dimensions.defaultTextSize,
                      color: CustomColor.blueColor,
                      decoration: TextDecoration.underline),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegistrationPage()));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

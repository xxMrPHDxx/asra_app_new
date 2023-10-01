import 'dart:convert';
import 'dart:developer';

import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/pages/dashboard/account.dart';
import 'package:asra_app_new/pages/dashboard/finance.dart';
import 'package:asra_app_new/pages/dashboard/offers.dart';
import 'package:asra_app_new/pages/dashboard/trip.dart';
import 'package:asra_app_new/pages/login.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/custom_style.dart';
import 'package:asra_app_new/utils/viewer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomepageMenuState {
  offers(Icons.grid_view_rounded, 'Job Offers'),
  trip(Icons.list, 'Active Trips'),
  finance(Icons.monetization_on, 'Finance'),
  report(Icons.library_books, 'Report'),
  account(Icons.person, 'Account');

  final IconData icon;
  final String title;
  const HomepageMenuState(this.icon, this.title);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class LoginData {
  final int id;
  final int userId;
  final String type;
  LoginData(this.id, this.userId, this.type);
}

LoginData getLoginData(final String token) {
  final String data =
      const Utf8Decoder().convert(base64Decode(token.split('.')[1]));
  final Map<String, dynamic> payload = jsonDecode(data);
  return LoginData(
    payload['ID'],
    payload['user_id'],
    payload['type'],
  );
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  int _currentPage = 0;
  late final String _token;
  late final LoginData _loginData;

  _HomePageState() {
    _loadToken();
  }

  void _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('AUTH_TOKEN')) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
      return;
    }
    _token = prefs.getString('AUTH_TOKEN')!;
    final response = await Api.json.get('/driver', {
      'Authorization': 'Bearer $_token',
    });
    if (!response['success']) {
      prefs.remove('AUTH_TOKEN');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return;
    }
    log('[AUTH Token]: $_token');
    _loginData = getLoginData(_token);
    setState(() => _loading = false);
  }

  Widget _renderPage() {
    switch (_currentPage) {
      case 0:
        return OffersPage(_loginData, _token);
      case 1:
        return TripsPage(_loginData, _token);
      case 2:
        return FinancePage(_loginData, _token);
      case 3:
        break;
      case 4:
        return AccountPage(_loginData, _token);
    }
    return Center(
      child: Text(
        'Not implemented!',
        style: CustomStyle.textStyle,
      ),
    );
  }

  Widget? _getFloatingButton(HomepageMenuState state) {
    switch (state) {
      case HomepageMenuState.offers:
        return FloatingActionButton.small(
          heroTag: 'addBlocking',
          tooltip: 'Add Blocking',
          child: const Icon(
            Icons.add,
            color: CustomColor.accentColor,
          ),
          onPressed: () {
            // showDialog(
            //   context: context,
            //   builder: (ctx) => HolidayWidget(
            //     onClick: (startDate, endDate) async {
            //       try {
            //         final response = await Api.json.post(
            //           '/driver/block',
            //           {
            //             'startDate': startDate,
            //             'endDate': endDate,
            //           },
            //           {
            //             'Authorization': 'Bearer $_token',
            //           },
            //         );
            //         if (!response['success']) {
            //           throw Exception(response['message']);
            //         }
            //         if (mounted) Navigator.of(context).pop();
            //       } catch (e) {
            //         if (e is Exception) {
            //           Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
            //         }
            //       }
            //     },
            //   ),
            // );
          },
        );
      case HomepageMenuState.account:
        return ExpandableFab(
          overlayStyle: ExpandableFabOverlayStyle(blur: 0.7),
          foregroundColor: CustomColor.accentColor,
          closeButtonStyle: const ExpandableFabCloseButtonStyle(
            foregroundColor: CustomColor.accentColor,
          ),
          children: [
            FloatingActionButton.small(
              heroTag: 'editProfile',
              tooltip: 'Edit Profile',
              child: const Icon(
                FontAwesomeIcons.userPen,
                color: CustomColor.accentColor,
              ),
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (ctx) => AccountEditPage(
                //     authToken: _token,
                //     loginData: _loginData,
                //   ),
                // ));
              },
            ),
            FloatingActionButton.small(
              heroTag: 'editVehicle',
              tooltip: 'Edit Vehicles',
              child: const Icon(
                FontAwesomeIcons.car,
                color: CustomColor.accentColor,
              ),
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (ctx) => VehicleEditPage(
                //     authToken: _token,
                //   ),
                // ));
              },
            ),
            FloatingActionButton.small(
              heroTag: 'showPermit',
              tooltip: 'Show Permit',
              child: const Icon(
                FontAwesomeIcons.circleInfo,
                color: CustomColor.accentColor,
              ),
              onPressed: () {
                showPdf(context, 'uploads/permit.pdf');
              },
            ),
          ],
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    HomepageMenuState page = HomepageMenuState.values[_currentPage];
    final fb = _getFloatingButton(page);
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.dstATop,
              ),
              image: const AssetImage('assets/background.jpg'),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(page.title),
              backgroundColor: CustomColor.primaryColor,
              foregroundColor: CustomColor.accentColor,
              automaticallyImplyLeading: false,
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : _renderPage(),
            bottomNavigationBar: CurvedNavigationBar(
              index: _currentPage,
              items: HomepageMenuState.values
                  .map((state) =>
                      Icon(state.icon, color: CustomColor.accentColor))
                  .toList(),
              backgroundColor: Colors.transparent,
              color: CustomColor.primaryColor,
              onTap: (idx) {
                setState(() {
                  _currentPage = idx;
                });
              },
            ),
            floatingActionButton: _loading ? null : fb,
            floatingActionButtonLocation:
                fb is ExpandableFab ? ExpandableFab.location : null,
          ),
        ),
        Positioned(
          bottom: 5,
          right: 10,
          child: Text(
            'ASRA Platform',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: CustomColor.accentColor,
                ),
          ),
        ),
      ],
    );
  }
}

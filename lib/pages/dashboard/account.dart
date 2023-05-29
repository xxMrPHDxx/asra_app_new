// import 'package:asra_app_new/widgets/memo.dart';
import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/widgets/memo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/pages/home.dart';

class AccountPage extends StatefulWidget {
  final LoginData loginData;
  final String authToken;

  const AccountPage(this.loginData, this.authToken, {Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _loading = true;
  late String _name, _email;
  late bool _trackingOn;

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  Future<void> _getInfo() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    _trackingOn = prefs.containsKey('TRACKING_ENABLED') ? prefs.getBool('TRACKING_ENABLED')! : false;
    final path = widget.loginData.type == 'host' ? '/host' : '/driver';
    final response = await Api.get(path, {
      'Authorization': 'Bearer ${widget.authToken}',
    });
    if (response['success']) {
      final info = response['info'];
      setState(() {
        _name = info['name'];
        _email = info['email'];
        _loading = false;
      });
    } else {
      Fluttertoast.showToast(msg: '[Error]: ${response["message"]}');
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('AUTH_TOKEN');
    if (mounted) Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                  ),
                  child: const FittedBox(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          'Name:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Flexible(
                          child: Text(
                            _name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Email: ',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Flexible(
                          child: Text(
                            _email,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.all(CustomColor.primaryColor),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
            onPressed: _logout,
            child: Text(S.of(context).signOut),
          ),
          if (widget.loginData.type != 'driver') const SizedBox(height: 10),
          if (widget.loginData.type != 'driver')
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enable GPS Update'),
                Switch(
                  value: _trackingOn,
                  onChanged: (tracking) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.reload();
                    if (tracking) {
                      await prefs.setBool('TRACKING_ENABLED', tracking);
                    } else {
                      await prefs.remove('TRACKING_ENABLED');
                    }
                    await Api.json.post(
                      '/driver/set_tracking',
                      {
                        'status': tracking ? 'Y' : 'N',
                      },
                      {
                        'Authorization': 'Bearer ${widget.authToken}',
                      },
                    );
                    setState(() {
                      _trackingOn = tracking;
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: MemoViewer(authToken: widget.authToken),
            ),
          ),
        ],
      ),
    );
  }
}

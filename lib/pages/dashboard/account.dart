import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/models/driver.dart';
import 'package:asra_app_new/models/host.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/widgets/editables.dart';
import 'package:asra_app_new/widgets/form_field.dart';
import 'package:asra_app_new/widgets/form_group.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/pages/home.dart';

class AccountPage extends StatefulWidget {
  final LoginData loginData;
  final String authToken;

  const AccountPage(this.loginData, this.authToken, {Key? key})
      : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _loading = true;
  late final dynamic _info;
  late bool _trackingOn;

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  Future<void> _getInfo() async {
    setState(() => _loading = true);
    Fluttertoast.showToast(msg: 'Type: ${widget.loginData.type}');
    _info = ['driver', 'partner'].contains(widget.loginData.type)
        ? Driver()
        : Host();
    final prefs = await SharedPreferences.getInstance();
    _trackingOn = prefs.containsKey('TRACKING_ENABLED')
        ? prefs.getBool('TRACKING_ENABLED')!
        : false;
    final path = widget.loginData.type == 'host' ? '/host' : '/driver';
    final response = await Api.json.get(path, {
      'Authorization': 'Bearer ${widget.authToken}',
    });
    if (response['success']) {
      final info = response['info'];
      setState(() {
        if (_info is Driver) {
          final driver = _info as Driver;
          driver.profilePic = info['profile_pic'] ?? '';
          driver.name = info['name'];
          driver.email = info['email'];
          driver.address = info['address'];
          driver.icDocument = info['ic_document'];
          driver.drivingLicense = info['driving_license'];
          driver.ehailingLicense = info['ehailing_license'];
          driver.ehailingInsurance = info['ehailing_insurance'];
          driver.carGrant = info['car_grant'];
          driver.drivingLicenseExpiry = info['driving_license_expiry'] ?? '';
          driver.ehailingLicenseExpiry = info['ehailing_license_expiry'] ?? '';
          driver.emergencyNumber = info['emergency_number'] ?? '';
        }
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Container(
              width: 120,
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Positioned(
                    child: ClipOval(
                      child: SizedBox.square(
                        dimension: 120,
                        child: Image.network(
                          Api.link('/${_info.profilePic}'),
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          dialogTitle: 'Choose Profile Photo',
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'png'],
                          withReadStream: true,
                          allowMultiple: false,
                        );
                        if (result == null) return;
                        final response =
                            await Api.multipart.post('/upload/image', {
                          'input': await MultipartFile.fromPath(
                            'input',
                            result.files[0].path!,
                          ),
                        });
                        if (!response['success']) {
                          Fluttertoast.showToast(
                            msg: 'Upload failed! Error: ${response['message']}',
                          );
                          return;
                        }
                        final update = await Api.json.patch('/driver', {
                          'profile_pic': response['path'],
                        }, {
                          'Authorization': 'Bearer ${widget.authToken}',
                        });
                        if (!update['success']) {
                          Fluttertoast.showToast(
                            msg: 'Update failed! Error: ${update['message']}',
                          );
                          return;
                        }
                        setState(() {
                          _info.profilePic = response['path'];
                        });
                        Fluttertoast.showToast(msg: 'Profile photo updated!');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FormGroup(
              label: 'Name',
              child: EditableFormField(
                enabled: !_loading,
                value: _info.name,
                onChanged: (val) async {
                  await Api.json.patch('/driver', {
                    'name': val,
                  }, {
                    'Authorization': 'Bearer ${widget.authToken}',
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            FormGroup(
              label: 'Email',
              child: CustomFormField(
                enabled: false,
                value: _info.email,
              ),
            ),
            const SizedBox(height: 20),
            FormGroup(
              label: 'Emergency Contact',
              child: EditableFormField(
                enabled: !_loading,
                value: _info.emergencyNumber,
                onChanged: (val) async {
                  await Api.json.patch('/driver', {
                    'emergency_number': val,
                  }, {
                    'Authorization': 'Bearer ${widget.authToken}',
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            FormGroup(
              label: 'Address',
              child: EditableFormField(
                enabled: !_loading,
                value: _info.address,
                onChanged: (val) async {
                  await Api.json.patch('/driver', {
                    'address': val,
                  }, {
                    'Authorization': 'Bearer ${widget.authToken}',
                  });
                },
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 20),
            CustomFileUploadField(
              enabled: !_loading,
              title: 'Identity Card',
              value: _info.icDocument,
              onChange: (path) async {
                final response = await Api.json.patch('/driver', {
                  'ic_document': path,
                }, {
                  'Authorization': 'Bearer ${widget.authToken}',
                });
                if (!response['success']) return;
                setState(() => _info.icDocument = path);
              },
            ),
            const SizedBox(height: 20),
            CustomFileUploadField(
              enabled: !_loading,
              title: 'Driving License',
              value: _info.drivingLicense,
              onChange: (path) async {
                final response = await Api.json.patch('/driver', {
                  'driving_license': path,
                }, {
                  'Authorization': 'Bearer ${widget.authToken}',
                });
                if (!response['success']) return;
                setState(() => _info.drivingLicense = path);
              },
            ),
            const SizedBox(height: 20),
            FormGroup(
              label: 'Driving License Expiry Date',
              child: DatePickerField(
                value: _info.drivingLicenseExpiry,
                onChanged: (date) async {
                  Fluttertoast.showToast(msg: 'Date: $date');
                  await Api.json.patch('/driver', {
                    'driving_license_expiry': date,
                  }, {
                    'Authorization': 'Bearer ${widget.authToken}',
                  });
                  setState(() {
                    _info.drivingLicenseExpiry = date;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            CustomFileUploadField(
              enabled: !_loading,
              title: 'E-Hailing License',
              value: _info.ehailingLicense,
              onChange: (path) async {
                final response = await Api.json.patch('/driver', {
                  'ehailing_license': path,
                }, {
                  'Authorization': 'Bearer ${widget.authToken}',
                });
                if (!response['success']) return;
                setState(() => _info.ehailingLicense = path);
              },
            ),
            const SizedBox(height: 20),
            FormGroup(
              label: 'E-Hailing License Expiry Date',
              child: DatePickerField(
                value: _info.ehailingLicenseExpiry,
                onChanged: (date) async {
                  Fluttertoast.showToast(msg: 'Date: $date');
                  await Api.json.patch('/driver', {
                    'ehailing_license_expiry': date,
                  }, {
                    'Authorization': 'Bearer ${widget.authToken}',
                  });
                  setState(() {
                    _info.ehailingLicenseExpiry = date;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            CustomFileUploadField(
              enabled: !_loading,
              title: 'E-Hailing Insurance',
              value: _info.ehailingInsurance,
              onChange: (path) async {
                final response = await Api.json.patch('/driver', {
                  'ehailing_insurance': path,
                }, {
                  'Authorization': 'Bearer ${widget.authToken}',
                });
                if (!response['success']) return;
                setState(() => _info.ehailingInsurance = path);
              },
            ),
            const SizedBox(height: 20),
            CustomFileUploadField(
              enabled: !_loading,
              title: 'Car Grant',
              value: _info.carGrant,
              onChange: (path) async {
                final response = await Api.json.patch('/driver', {
                  'car_grant': path,
                }, {
                  'Authorization': 'Bearer ${widget.authToken}',
                });
                if (!response['success']) return;
                setState(() => _info.carGrant = path);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all(CustomColor.primaryColor),
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
          ],
        ),
      ),
    );
  }
}

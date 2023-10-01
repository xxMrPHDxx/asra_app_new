import 'dart:io';

import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/models/driver.dart';
import 'package:asra_app_new/models/host.dart';
import 'package:asra_app_new/models/owner.dart';
import 'package:asra_app_new/models/vehicle.dart';
import 'package:asra_app_new/pages/registration/driver_info.dart';
import 'package:asra_app_new/pages/registration/driver_type.dart';
import 'package:asra_app_new/pages/registration/host_info.dart';
import 'package:asra_app_new/pages/registration/vehicles_info.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/error.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/templates.dart';

enum _RegisterType {
  driver(2),
  hosting(3),
  partner(1);

  final int id;
  const _RegisterType(this.id);
}

class RegisteredUser {
  final int id;
  final int userId;
  final String token;
  RegisteredUser({
    required this.id,
    required this.userId,
    required this.token,
  });
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _driver = Driver(), _host = Host();
  int _page = 0;
  _RegisterType? _registerType;
  final List<Owner> _owners = [];
  bool _loading = false;

  void _register() async {
    if (_registerType == null) return;
    setState(() {
      _loading = true;
    });
    try {
      final RegisteredUser user;
      if (_registerType! == _RegisterType.hosting) {
        user = await _registerHost();
      } else {
        user = await _registerDriver(
          _registerType! == _RegisterType.partner ? 1 : 2,
        );
      }
      if (_registerType! != _RegisterType.driver) {
        for (final owner in _owners) {
          owner.vehicle.ownerId = await _registerOwner(owner);
          owner.vehicle.id = await _registerVehicle(
            owner.vehicle,
            user,
          );
          if (_registerType! == _RegisterType.partner) {
            final res = await Api.json.post('/driver/vehicle', {
              'vehicle_id': owner.vehicle.id,
            }, {
              'Authorization': 'Bearer ${user.token}',
            });
            if (!res['success']) {
              throw Error(res['success']);
            } else {
              Fluttertoast.showToast(msg: 'Successfully assigned vehicle!');
            }
          }
        }
      }
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    } on Error catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<int> _registerVehicle(Vehicle vehicle, RegisteredUser host) async {
    try {
      final response = await Api.json.post('/vehicle/register', {
        'owner_id': vehicle.ownerId,
        'plate': vehicle.plateNo,
        'model_id': vehicle.modelId,
        'host_id': host.id,
        'insurance': vehicle.insurancePath,
        'roadtax': vehicle.roadTaxPath,
        'owner_approval': vehicle.ownerApprovalPath,
        'front_view': vehicle.frontView,
        'left_view': vehicle.leftView,
        'right_view': vehicle.rightView,
        'rear_view': vehicle.rearView,
        'inner_view': vehicle.innerView,
      }, {
        'Authorization': 'Bearer ${host.token}',
      });
      if (!response['success']) throw Error(response['message']);
      return response['vehicle_id'];
    } catch (e) {
      if (e is Error) {
        throw Error('Vehicle registration failed: ${e.message}');
      } else if (e is FileSystemException) {
        throw Error('Some file(s) cannot be opened! [Path=${e.path}]');
      } else {
        rethrow;
      }
    }
  }

  Future<int> _registerOwner(Owner owner) async {
    try {
      final response = await Api.json.post('/owner/register', {
        'name': owner.name,
        'gender': owner.gender,
        'phone_no': owner.phone,
        'address': owner.address,
        'ic_number': owner.ic,
        'bank_name': owner.bankName,
        'bank_no': owner.bankNo,
        'ic_doc': owner.icPath,
        'bank_doc': owner.bankStatementPath,
      });
      if (!response['success']) throw Error(response['message']);
      return response['owner_id'];
    } catch (e) {
      if (e is Error) {
        throw Error('Owner registration failed: ${e.message}');
      } else if (e is FileSystemException) {
        throw Error('Some file(s) cannot be opened! [Path=${e.path}]');
      }
      rethrow;
    }
  }

  Future<RegisteredUser> _registerHost() async {
    try {
      final response = await Api.json.post('/host/register', {
        'name': _host.name,
        'ic_number': _host.icNumber,
        'gender': _host.gender,
        'phone_no': _host.phone,
        'address': _host.address,
        'email': _host.email,
        'password': _host.password,
        'ic_doc': _host.icPath,
        'bank_doc': _host.bankPath,
      });
      if (!response['success']) throw Error(response['message']);
      return RegisteredUser(
        id: response['ID'],
        userId: response['user_id'],
        token: response['token'],
      );
    } catch (e) {
      if (e is Error) {
        throw Error('Driver registration failed: ${e.message}');
      } else if (e is FileSystemException) {
        throw Error('Some file(s) cannot be opened! [Path=${e.path}]');
      }
      rethrow;
    }
  }

  Future<RegisteredUser> _registerDriver(int driverType) async {
    try {
      final response = await Api.json.post('/driver/register', {
        'driver_type': driverType,
        'name': _driver.name,
        'email': _driver.email,
        'ic_number': _driver.icNumber,
        'phone_no': _driver.phone,
        'password': _driver.password,
        'address': _driver.address,
        'ic_doc': _driver.icDocument,
        'license_doc': _driver.drivingLicense,
        'ehailing_license': _driver.ehailingLicense,
        'ehailing_insurance': _driver.ehailingInsurance,
        'car_grant': _driver.carGrant,
      });
      if (!response['success']) {
        throw Error(response['message']);
      }
      return RegisteredUser(
        id: response['ID'],
        userId: response['user_id'],
        token: response['token'],
      );
    } catch (e) {
      if (e is Error) {
        throw Error('Driver registration failed: ${e.message}');
      } else if (e is FileSystemException) {
        throw Error('Some file(s) cannot be opened! [Path=${e.path}]');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_page == 3) {
      return TopImageTemplateWidget(
        child: Column(
          children: [
            Text(
              S.of(context).registerVehicle,
              style: GoogleFonts.roboto(
                fontSize: Dimensions.extraLargeTextSize,
                fontWeight: FontWeight.bold,
                color: CustomColor.primaryColor,
              ),
            ),
            const SizedBox(height: Dimensions.heightSize * 3),
            VehiclesInfoRegistration(
              enabled: !_loading,
              owners: _owners,
              limit: _registerType == _RegisterType.partner ? 1 : null,
              onAdded: (owner) {
                setState(() {
                  _owners.add(owner);
                });
              },
              onRemoved: (owner) {
                setState(() {
                  _owners.remove(owner);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () {
                          setState(() {
                            _page -=
                                _registerType == _RegisterType.hosting ? 1 : 2;
                          });
                        },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: _loading || _owners.isEmpty
                      ? null
                      : () {
                          if (_registerType != _RegisterType.driver) {
                            _register();
                          }
                        },
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      );
    }
    if (_page == 2) {
      return HostInfoRegistration(
        enabled: !_loading,
        host: _host,
        onPrev: () {
          setState(() {
            _page = 0;
          });
        },
        onNext: () {
          setState(() {
            _page++;
          });
        },
      );
    }
    if (_page == 1) {
      return DriverInfoRegistration(
        hasNext: _registerType != null && _registerType != _RegisterType.driver,
        enabled: !_loading,
        driver: _driver,
        onPrev: () {
          setState(() {
            _page--;
          });
        },
        onNext: () {
          setState(() {
            if (_registerType == _RegisterType.driver) {
              _register();
            } else {
              _page = 3;
            }
          });
        },
      );
    }
    return DriverTypeRegistration(
      value: _registerType?.id,
      onChange: (val) {
        setState(() {
          switch (val) {
            case 1:
              _registerType = _RegisterType.partner;
              break;
            case 2:
              _registerType = _RegisterType.driver;
              break;
            case 3:
              _registerType = _RegisterType.hosting;
              break;
          }
        });
      },
      onNext: () => setState(() {
        if (_registerType == null) return;
        _page = _registerType == _RegisterType.hosting ? 2 : 1;
      }),
    );
  }
}

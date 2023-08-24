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
import 'package:http/http.dart';

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
  final String token;
  RegisteredUser({
    required this.id,
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
        id: response['user_id'],
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
        id: response['user_id'],
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
            default:
              return;
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

// class _RegistrationPageState extends State<RegistrationPage> {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController homeAddressController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   bool _toggleVisibility = true;
//   bool checkTermsConditions = false;

//   @override
//   void initState() {
//     super.initState();

//     mobileController.text = '+1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TopImageTemplateWidget(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             S.of(context).signUpWithMobileNumber,
//             textAlign: TextAlign.center,
//             style: GoogleFonts.roboto(
//               fontSize: Dimensions.extraLargeTextSize,
//               fontWeight: FontWeight.bold,
//               color: CustomColor.primaryColor,
//             ),
//           ),
//           const SizedBox(height: Dimensions.heightSize * 3),
//           Text(
//             S.of(context).firstName,
//             textAlign: TextAlign.start,
//             style: GoogleFonts.roboto(
//               fontSize: Dimensions.defaultTextSize,
//               color: CustomColor.primaryColor,
//             ),
//           ),
//           const SizedBox(height: Dimensions.heightSize * 0.5),
//           TextFormField(
//             style: CustomStyle.textStyle,
//             controller: firstNameController,
//             keyboardType: TextInputType.name,
//             validator: (value) {
//               if (value == null || value.isEmpty) return S.of(context).pleaseFillOutTheField;
//               return null;
//             },
//             decoration: InputDecoration(
//               hintText: S.of(context).demoFirstName,
//               contentPadding: const EdgeInsets.all(10.0),
//               labelStyle: CustomStyle.textStyle,
//               filled: true,
//               fillColor: Colors.white,
//               hintStyle: CustomStyle.hintTextStyle,
//               focusedBorder: CustomStyle.focusBorder,
//               enabledBorder: CustomStyle.focusErrorBorder,
//               focusedErrorBorder: CustomStyle.focusErrorBorder,
//               errorBorder: CustomStyle.focusErrorBorder,
//             ),
//           ),
//           const SizedBox(height: Dimensions.heightSize),
//           Text(
//             S.of(context).lastName,
//             style: GoogleFonts.roboto(
//               fontSize: Dimensions.defaultTextSize,
//               color: CustomColor.primaryColor,
//             ),
//           ),
//           const SizedBox(height: Dimensions.heightSize * 0.5),
//           TextFormField(
//             style: CustomStyle.textStyle,
//             controller: lastNameController,
//             keyboardType: TextInputType.name,
//             validator: (value) {
//               if (value == null || value.isEmpty) return S.of(context).pleaseFillOutTheField;
//               return null;
//             },
//             decoration: InputDecoration(
//               hintText: S.of(context).demoLastName,
//               contentPadding: const EdgeInsets.all(10.0),
//               labelStyle: CustomStyle.textStyle,
//               filled: true,
//               fillColor: Colors.white,
//               hintStyle: CustomStyle.hintTextStyle,
//               focusedBorder: CustomStyle.focusBorder,
//               enabledBorder: CustomStyle.focusErrorBorder,
//               focusedErrorBorder: CustomStyle.focusErrorBorder,
//               errorBorder: CustomStyle.focusErrorBorder,
//             ),
//           ),
//           const SizedBox(height: Dimensions.heightSize),
//           Text(
//             S.of(context).homeAddress,
//             style: GoogleFonts.roboto(
//               fontSize: Dimensions.defaultTextSize,
//               color: CustomColor.primaryColor,
//             ),
//           ),
//           const SizedBox(height: Dimensions.heightSize * 0.5),
//           TextFormField(
//             style: CustomStyle.textStyle,
//             controller: homeAddressController,
//             keyboardType: TextInputType.name,
//             validator: (value) {
//               if (value == null || value.isEmpty) return S.of(context).pleaseFillOutTheField;
//               return null;
//             },
//             decoration: InputDecoration(
//               hintText: S.of(context).homeAddress,
//               contentPadding: const EdgeInsets.all(10.0),
//               labelStyle: CustomStyle.textStyle,
//               filled: true,
//               fillColor: Colors.white,
//               hintStyle: CustomStyle.hintTextStyle,
//               focusedBorder: CustomStyle.focusBorder,
//               enabledBorder: CustomStyle.focusErrorBorder,
//               focusedErrorBorder: CustomStyle.focusErrorBorder,
//               errorBorder: CustomStyle.focusErrorBorder,
//             ),
//           ),
//           const SizedBox(height: Dimensions.heightSize),
//           Text(
//             S.of(context).phone,
//             style: GoogleFonts.roboto(
//               fontSize: Dimensions.defaultTextSize,
//               color: CustomColor.primaryColor,
//             ),
//           ),
//           const SizedBox(height: Dimensions.heightSize * 0.5),
//           TextFormField(
//             style: CustomStyle.textStyle,
//             controller: passwordController,
//             validator: (value) {
//               if (value == null || value.isEmpty) return S.of(context).pleaseFillOutTheField;
//               return null;
//             },
//             decoration: InputDecoration(
//               hintText: S.of(context).demoPassword,
//               contentPadding: const EdgeInsets.all(10.0),
//               labelStyle: CustomStyle.textStyle,
//               focusedBorder: CustomStyle.focusBorder,
//               enabledBorder: CustomStyle.focusErrorBorder,
//               focusedErrorBorder: CustomStyle.focusErrorBorder,
//               errorBorder: CustomStyle.focusErrorBorder,
//               filled: true,
//               fillColor: Colors.white,
//               hintStyle: CustomStyle.hintTextStyle,
//               suffixIcon: IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _toggleVisibility = !_toggleVisibility;
//                   });
//                 },
//                 icon: _toggleVisibility
//                     ? Icon(
//                         Icons.visibility_off,
//                         color: Colors.black.withOpacity(0.2),
//                       )
//                     : Icon(
//                         Icons.visibility,
//                         color: Colors.black.withOpacity(0.2),
//                       ),
//               ),
//             ),
//             obscureText: _toggleVisibility,
//           ),
//           const SizedBox(height: Dimensions.heightSize),
//           CustomCheckboxField(
//             title: Flexible(
//               fit: FlexFit.loose,
//               child: RichText(
//                 textAlign: TextAlign.start,
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: S.of(context).iConfirmThat,
//                       style: CustomStyle.textStyle,
//                     ),
//                     TextSpan(
//                       text: S.of(context).termsCondition,
//                       style: GoogleFonts.roboto(
//                         color: CustomColor.primaryColor,
//                         fontSize: Dimensions.defaultTextSize,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           showTermsConditions();
//                         },
//                     ),
//                     TextSpan(
//                       text: S.of(context).and,
//                       style: CustomStyle.textStyle,
//                     ),
//                     TextSpan(
//                       text: S.of(context).privacyPolicy,
//                       style: GoogleFonts.roboto(
//                         color: CustomColor.primaryColor,
//                         fontSize: Dimensions.defaultTextSize,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           showTermsConditions();
//                         },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             checked: checkTermsConditions,
//             onToggle: (tnc) => setState(() => checkTermsConditions = tnc),
//           ),
//           const SizedBox(height: Dimensions.heightSize * 3),
//           CustomButton(
//             text: S.of(context).next.toUpperCase(),
//             onClick: () {
//               // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonalInformationScreen()));
//             },
//           ),
//           const SizedBox(height: Dimensions.heightSize * 2),
//           RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: S.of(context).alreadyHaveAnAccount,
//                   style: CustomStyle.textStyle,
//                 ),
//                 TextSpan(
//                   text: S.of(context).signIn,
//                   style: TextStyle(
//                     fontSize: Dimensions.defaultTextSize,
//                     color: CustomColor.blueColor,
//                     decoration: TextDecoration.underline,
//                   ),
//                   recognizer: TapGestureRecognizer()
//                     ..onTap = () {
//                       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen()));
//                     },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<bool> showTermsConditions() async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             color: CustomColor.primaryColor,
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: Dimensions.defaultPaddingSize * 2, bottom: Dimensions.defaultPaddingSize * 2),
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: AlertDialog(
//                         content: Stack(
//                       children: [
//                         Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           bottom: 45,
//                           child: SingleChildScrollView(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: Dimensions.heightSize * 2),
//                                 Text(
//                                   S.of(context).ourPolicyTerms,
//                                   style: GoogleFonts.roboto(
//                                     color: Colors.black.withOpacity(0.7),
//                                     fontSize: Dimensions.largeTextSize,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: Dimensions.heightSize),
//                                 Text(
//                                   'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old',
//                                   style: CustomStyle.textStyle,
//                                 ),
//                                 const SizedBox(height: Dimensions.heightSize),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '•',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: CustomColor.accentColor,
//                                         fontSize: Dimensions.extraLargeTextSize,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 5.0),
//                                     Expanded(
//                                       child: Text(
//                                         'simply random text. It has roots in a piece of classical Latin literature ',
//                                         style: CustomStyle.textStyle,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: Dimensions.heightSize),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '•',
//                                       style: TextStyle(fontWeight: FontWeight.bold, color: CustomColor.accentColor, fontSize: Dimensions.extraLargeTextSize),
//                                     ),
//                                     const SizedBox(width: 5.0),
//                                     Expanded(
//                                       child: Text(
//                                         'Distracted by the readable content of a page when looking at its layout.',
//                                         style: CustomStyle.textStyle,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: Dimensions.heightSize),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '•',
//                                       style: TextStyle(fontWeight: FontWeight.bold, color: CustomColor.accentColor, fontSize: Dimensions.extraLargeTextSize),
//                                     ),
//                                     const SizedBox(width: 5.0),
//                                     Expanded(
//                                       child: Text(
//                                         'Available, but the majority have suffered alteration',
//                                         style: CustomStyle.textStyle,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: Dimensions.heightSize * 2,
//                                 ),
//                                 Text(
//                                   'When do we contact information ?',
//                                   style: GoogleFonts.roboto(color: Colors.black.withOpacity(0.7), fontSize: Dimensions.largeTextSize, fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: Dimensions.heightSize),
//                                 Text(
//                                   'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old',
//                                   style: CustomStyle.textStyle,
//                                 ),
//                                 const SizedBox(
//                                   height: Dimensions.heightSize * 2,
//                                 ),
//                                 Text(
//                                   'Do we use cookies ?',
//                                   style: GoogleFonts.roboto(
//                                     color: Colors.black.withOpacity(0.7),
//                                     fontSize: Dimensions.largeTextSize,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: Dimensions.heightSize),
//                                 Text(
//                                   'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old',
//                                   style: CustomStyle.textStyle,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: Align(
//                               alignment: Alignment.bottomCenter,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   GestureDetector(
//                                     child: Container(
//                                       height: 35.0,
//                                       width: 100.0,
//                                       decoration: BoxDecoration(color: CustomColor.yellowLightColor, borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                                       child: Center(
//                                         child: Text(
//                                           S.of(context).decline,
//                                           style: GoogleFonts.roboto(color: Colors.grey, fontSize: Dimensions.defaultTextSize),
//                                         ),
//                                       ),
//                                     ),
//                                     onTap: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                   SizedBox(
//                                     width: 10.0,
//                                   ),
//                                   GestureDetector(
//                                     child: Container(
//                                       height: 35.0,
//                                       width: 100.0,
//                                       decoration: BoxDecoration(color: CustomColor.accentColor, borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                                       child: Center(
//                                         child: Text(
//                                           S.of(context).agree,
//                                           style: GoogleFonts.roboto(color: Colors.white, fontSize: Dimensions.defaultTextSize),
//                                         ),
//                                       ),
//                                     ),
//                                     onTap: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     )),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )) ??
//         false;
//   }
// }

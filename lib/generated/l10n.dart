// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Please Fill Out This Field`
  String get errorEmpty {
    return Intl.message(
      'Please Fill Out This Field',
      name: 'errorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Ubax Driver`
  String get appName {
    return Intl.message(
      'Ubax Driver',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Perfect taxi booking apps for your safety and comfortable trip`
  String get perfectTaxiBooking {
    return Intl.message(
      'Perfect taxi booking apps for your safety and comfortable trip',
      name: 'perfectTaxiBooking',
      desc: '',
      args: [],
    );
  }

  /// `Accept a Job`
  String get title1 {
    return Intl.message(
      'Accept a Job',
      name: 'title1',
      desc: '',
      args: [],
    );
  }

  /// `Perfect taxi booking apps for your safety and comfortable trip`
  String get subTitle1 {
    return Intl.message(
      'Perfect taxi booking apps for your safety and comfortable trip',
      name: 'subTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Tracking Realtime`
  String get title2 {
    return Intl.message(
      'Tracking Realtime',
      name: 'title2',
      desc: '',
      args: [],
    );
  }

  /// `Perfect taxi booking apps for your safety and comfortable trip`
  String get subTitle2 {
    return Intl.message(
      'Perfect taxi booking apps for your safety and comfortable trip',
      name: 'subTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Earn Money`
  String get title3 {
    return Intl.message(
      'Earn Money',
      name: 'title3',
      desc: '',
      args: [],
    );
  }

  /// `Perfect taxi booking apps for your safety and comfortable trip`
  String get subTitle3 {
    return Intl.message(
      'Perfect taxi booking apps for your safety and comfortable trip',
      name: 'subTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAnAccount {
    return Intl.message(
      'Create an account',
      name: 'createAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Account`
  String get signInAccount {
    return Intl.message(
      'Sign In Account',
      name: 'signInAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please Fill Out The Field`
  String get pleaseFillOutTheField {
    return Intl.message(
      'Please Fill Out The Field',
      name: 'pleaseFillOutTheField',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me`
  String get rememberMe {
    return Intl.message(
      'Remember Me',
      name: 'rememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password? `
  String get forgotPassword {
    return Intl.message(
      'Forgot Password? ',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have account? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have account? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up With Mobile Number`
  String get signUpWithMobileNumber {
    return Intl.message(
      'Sign Up With Mobile Number',
      name: 'signUpWithMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Home Address`
  String get homeAddress {
    return Intl.message(
      'Home Address',
      name: 'homeAddress',
      desc: '',
      args: [],
    );
  }

  /// `I confirm that I have read & agree to the `
  String get iConfirmThat {
    return Intl.message(
      'I confirm that I have read & agree to the ',
      name: 'iConfirmThat',
      desc: '',
      args: [],
    );
  }

  /// `Terms & condition`
  String get termsCondition {
    return Intl.message(
      'Terms & condition',
      name: 'termsCondition',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(
      ' and ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Jhon`
  String get demoFirstName {
    return Intl.message(
      'Jhon',
      name: 'demoFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Doe`
  String get demoLastName {
    return Intl.message(
      'Doe',
      name: 'demoLastName',
      desc: '',
      args: [],
    );
  }

  /// `Park road London 5487`
  String get demoHomeAddress {
    return Intl.message(
      'Park road London 5487',
      name: 'demoHomeAddress',
      desc: '',
      args: [],
    );
  }

  /// `8745 251 369`
  String get demoPhoneNumber {
    return Intl.message(
      '8745 251 369',
      name: 'demoPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `A456789@1234`
  String get demoPassword {
    return Intl.message(
      'A456789@1234',
      name: 'demoPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Our policy and terms`
  String get ourPolicyTerms {
    return Intl.message(
      'Our policy and terms',
      name: 'ourPolicyTerms',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get agree {
    return Intl.message(
      'Agree',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `Decline`
  String get decline {
    return Intl.message(
      'Decline',
      name: 'decline',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Birth Certificate`
  String get birthCertificate {
    return Intl.message(
      'Birth Certificate',
      name: 'birthCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Registration`
  String get vehicleRegistration {
    return Intl.message(
      'Vehicle Registration',
      name: 'vehicleRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Driving Licence`
  String get drivingLicence {
    return Intl.message(
      'Driving Licence',
      name: 'drivingLicence',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect`
  String get incorrect {
    return Intl.message(
      'Incorrect',
      name: 'incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Passport`
  String get passport {
    return Intl.message(
      'Passport',
      name: 'passport',
      desc: '',
      args: [],
    );
  }

  /// `A Passport is travel doc`
  String get aPassportIsTravel {
    return Intl.message(
      'A Passport is travel doc',
      name: 'aPassportIsTravel',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `NID`
  String get nid {
    return Intl.message(
      'NID',
      name: 'nid',
      desc: '',
      args: [],
    );
  }

  /// `A country national card `
  String get aCountry {
    return Intl.message(
      'A country national card ',
      name: 'aCountry',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `OTP Verification`
  String get otpVerification {
    return Intl.message(
      'OTP Verification',
      name: 'otpVerification',
      desc: '',
      args: [],
    );
  }

  /// `We Will Send You That Code`
  String get weWillSendYou {
    return Intl.message(
      'We Will Send You That Code',
      name: 'weWillSendYou',
      desc: '',
      args: [],
    );
  }

  /// `One Time Password`
  String get oneTimePassword {
    return Intl.message(
      'One Time Password',
      name: 'oneTimePassword',
      desc: '',
      args: [],
    );
  }

  /// `On This Mobile Number`
  String get onThisMobileNumber {
    return Intl.message(
      'On This Mobile Number',
      name: 'onThisMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Mobile Number`
  String get enterMobileNumber {
    return Intl.message(
      'Enter Mobile Number',
      name: 'enterMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Get OTP`
  String get getOTP {
    return Intl.message(
      'Get OTP',
      name: 'getOTP',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP Sent To`
  String get enterOtpSentTo {
    return Intl.message(
      'Enter OTP Sent To',
      name: 'enterOtpSentTo',
      desc: '',
      args: [],
    );
  }

  /// `Go`
  String get go {
    return Intl.message(
      'Go',
      name: 'go',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message(
      'Stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `You're`
  String get your {
    return Intl.message(
      'You\'re',
      name: 'your',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `Acceptance`
  String get acceptance {
    return Intl.message(
      'Acceptance',
      name: 'acceptance',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation`
  String get cancellation {
    return Intl.message(
      'Cancellation',
      name: 'cancellation',
      desc: '',
      args: [],
    );
  }

  /// `Accept Ride`
  String get acceptRide {
    return Intl.message(
      'Accept Ride',
      name: 'acceptRide',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Profile Overview`
  String get profileOverview {
    return Intl.message(
      'Profile Overview',
      name: 'profileOverview',
      desc: '',
      args: [],
    );
  }

  /// `Your Earning`
  String get yourEarning {
    return Intl.message(
      'Your Earning',
      name: 'yourEarning',
      desc: '',
      args: [],
    );
  }

  /// `My Wallet`
  String get myWallet {
    return Intl.message(
      'My Wallet',
      name: 'myWallet',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get signOut {
    return Intl.message(
      'Logout',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Ride`
  String get cancelRide {
    return Intl.message(
      'Cancel Ride',
      name: 'cancelRide',
      desc: '',
      args: [],
    );
  }

  /// `Rider isn't here`
  String get reason1 {
    return Intl.message(
      'Rider isn`t here',
      name: 'reason1',
      desc: '',
      args: [],
    );
  }

  /// `Wrong address show`
  String get reason2 {
    return Intl.message(
      'Wrong address show',
      name: 'reason2',
      desc: '',
      args: [],
    );
  }

  /// `Don't charge rider`
  String get reason3 {
    return Intl.message(
      'Don`t charge rider',
      name: 'reason3',
      desc: '',
      args: [],
    );
  }

  /// `No location show`
  String get reason4 {
    return Intl.message(
      'No location show',
      name: 'reason4',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Cancel`
  String get yesCancel {
    return Intl.message(
      'Yes, Cancel',
      name: 'yesCancel',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Arrived Jonson Wiliam`
  String get arrivedUser {
    return Intl.message(
      'Arrived Jonson Wiliam',
      name: 'arrivedUser',
      desc: '',
      args: [],
    );
  }

  /// `Finish Ride`
  String get finishRide {
    return Intl.message(
      'Finish Ride',
      name: 'finishRide',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'phoneNumber ' key

  // skipped getter for the 'typeSomething ' key

  // skipped getter for the 'typeMessage ' key

  // skipped getter for the 'rideInvoice ' key

  // skipped getter for the 'iGotPayment ' key

  // skipped getter for the 'earning ' key

  // skipped getter for the 'today ' key

  // skipped getter for the 'weekly ' key

  // skipped getter for the 'monthly ' key

  // skipped getter for the 'totalRide ' key

  // skipped getter for the 'onlineHrs ' key

  // skipped getter for the 'totalEarning ' key

  // skipped getter for the 'rideYellow ' key

  // skipped getter for the 'greenTaxi ' key

  // skipped getter for the 'yahoma ' key

  // skipped getter for the 'sajuka ' key

  // skipped getter for the 'total ' key

  // skipped getter for the 'addNewCard ' key

  // skipped getter for the 'oldPassword ' key

  // skipped getter for the 'newPassword ' key

  // skipped getter for the 'confirmPassword ' key

  // skipped getter for the 'typePassword ' key

  // skipped getter for the 'demoCardNumber ' key

  // skipped getter for the 'demoHolderName ' key

  // skipped getter for the 'validForm ' key

  // skipped getter for the 'validThru ' key

  // skipped getter for the 'cardType ' key

  // skipped getter for the 'cardNumber ' key

  // skipped getter for the 'cardHolderName ' key

  // skipped getter for the 'expirationDate ' key

  // skipped getter for the 'cvv ' key

  // skipped getter for the 'saveCard ' key

  // skipped getter for the 'howYourPassenger ' key

  // skipped getter for the 'giveRating ' key

  // skipped getter for the 'behaviour ' key

  // skipped getter for the 'payment ' key

  // skipped getter for the 'meetAgain ' key

  // skipped getter for the 'communication ' key

  // skipped getter for the 'yourComment ' key

  // skipped getter for the 'riderFeedback ' key

  // skipped getter for the 'notNow ' key

  /// `Vehicles Registration`
  String get registerVehicle {
    return Intl.message(
      'Vehicles Registration',
      name: 'registerVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Driver Information`
  String get registerDriver {
    return Intl.message(
      'Driver Information',
      name: 'registerDriver',
      desc: '',
      args: [],
    );
  }

  /// `Select Type`
  String get registrationType {
    return Intl.message(
      'Select Type',
      name: 'registrationType',
      desc: '',
      args: [],
    );
  }

  /// `Host Information`
  String get registerHost {
    return Intl.message(
      'Host Information',
      name: 'registerHost',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

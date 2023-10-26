import 'dart:async';
import 'dart:ui';

import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/pages/home.dart';
import 'package:asra_app_new/pages/login.dart';
import 'package:asra_app_new/pages/onboard.dart';
import 'package:asra_app_new/pages/register.dart';
import 'package:asra_app_new/pages/splash.dart';
import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:callkeep/callkeep.dart';

const notificationId = 'ASRA_NotificationChannel';
const notificationTitle = 'ASRA Travel';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  const settings = InitializationSettings(android: android, iOS: ios);

  final plugin = FlutterLocalNotificationsPlugin();
  const androidChannelSpecifics = AndroidNotificationDetails(
    notificationId,
    notificationTitle,
    importance: Importance.low,
  );
  const iOSChannelSpecifics = DarwinNotificationDetails();

  NotificationDetails? platformChannelSpecifics = const NotificationDetails(
    android: androidChannelSpecifics,
    iOS: iOSChannelSpecifics,
  );
  await plugin.initialize(settings);

  BackgroundLocation.getLocationUpdates((loc) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (!prefs.containsKey('AUTH_TOKEN') ||
        !prefs.containsKey('TRACKING_ENABLED')) return;
    final token = prefs.getString('AUTH_TOKEN')!;
    await Api.json.post(
      '/driver/locate',
      {
        'latitude': loc.latitude,
        'longitude': loc.longitude,
      },
      {
        'Authorization': 'Bearer $token',
      },
    );
  });

  final socket = sio.io(
    'http://103.18.244.31:3000',
    sio.OptionBuilder().setTransports(['websocket']).enableForceNew().build(),
  );

  int id = 1;
  socket.on('notification', (notification) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('AUTH_TOKEN')) return;
    final login = getLoginData(prefs.getString('AUTH_TOKEN')!);
    final drivers = notification['drivers'] as List;
    if (drivers.contains(login.id)) {
      plugin.show(
        ++id,
        notification['title'],
        notification['message'],
        platformChannelSpecifics,
      );
    }
    if (id > 10) id = 1;
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  socket.connect();

  BackgroundLocation.setAndroidConfiguration(5000);
  BackgroundLocation.startLocationService();
}

final _callKeep = FlutterCallkeep();
bool _callKeepInited = false;
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print('backgroundMessage: message => ${message.toString()}');
  var payload = message['data'];
  var callerId = payload['caller_id'] as String;
  var callerName = payload['caller_name'] as String;
  var uuid = payload['uuid'] as String;
  var hasVideo = payload['has_video'] == "true";

  final callUUID = uuid;
  _callKeep.on(CallKeepPerformAnswerCallAction(),
      (CallKeepPerformAnswerCallAction event) {
    print(
        'backgroundMessage: CallKeepPerformAnswerCallAction ${event.callUUID}');
    Timer(const Duration(seconds: 1), () {
      print(
          '[setCurrentCallActive] $callUUID, callerId: $callerId, callerName: $callerName');
      _callKeep.setCurrentCallActive(callUUID);
    });
    //_callKeep.endCall(event.callUUID);
  });

  _callKeep.on(CallKeepPerformEndCallAction(),
      (CallKeepPerformEndCallAction event) {
    print('backgroundMessage: CallKeepPerformEndCallAction ${event.callUUID}');
  });
  if (!_callKeepInited) {
    _callKeep.setup(
        null,
        <String, dynamic>{
          'ios': {
            'appName': 'CallKeepDemo',
          },
          'android': {
            'alertTitle': 'Permissions required',
            'alertDescription':
                'This application needs to access your phone accounts',
            'cancelButton': 'Cancel',
            'okButton': 'ok',
            'foregroundService': {
              'channelId': 'com.company.my',
              'channelName': 'Foreground service for my app',
              'notificationTitle': 'My app is running on background',
              'notificationIcon':
                  'Path to the resource icon of the notification',
            },
          },
        },
        backgroundMode: true);
    _callKeepInited = true;
  }

  print('backgroundMessage: displayIncomingCall ($callerId)');
  _callKeep.displayIncomingCall(callUUID, callerId,
      localizedCallerName: callerName, hasVideo: hasVideo);
  _callKeep.backToForeground();
  /*

  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('notification => ${notification.toString()}');
  }

  // Or do other work.
  */
  return true as dynamic;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await initializeDateFormatting();

  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
      notificationChannelId: notificationId,
      foregroundServiceNotificationId: 0,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,

      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      // onBackground: onIosBackground,
    ),
  );
  await service.startService();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await initializeDateFormatting('en', 'assets/');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        S.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
            fixedSize: MaterialStateProperty.all(const Size.fromHeight(42)),
            textStyle: MaterialStateProperty.resolveWith((states) {
              return const TextStyle(
                fontWeight: FontWeight.bold,
              );
            }),
            foregroundColor: MaterialStateProperty.all(Colors.black87),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey.shade400;
              }
              final color = Theme.of(context).colorScheme.tertiary;
              if (states.contains(MaterialState.pressed)) {
                return color.withAlpha(100);
              }
              return color;
            }),
          ),
        ),
        textTheme: const TextTheme(
          labelLarge: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.blueAccent),
          headlineMedium: TextStyle(fontSize: 22),
          headlineSmall: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            fontSize: 11,
          ),
        ),
        primaryColor: Colors.white,
        colorScheme: ColorScheme.light(
          background: Colors.black,
          primary: Colors.grey,
          secondary: Colors.blue.shade900,
          tertiary: Colors.yellowAccent,
          error: Colors.red,
          surface: Colors.grey.shade300,
        ),
      ),
      initialRoute: '/',
      home: const SplashPage(),
      routes: {
        '/welcome': (context) => const OnBoardPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
      },
    );
  }
}
